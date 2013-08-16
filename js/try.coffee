$('<script src="lib/dist/batman.jquery.js"></script>').appendTo('head')
$('<script src="lib/extras/batman.rails.js"></script>').appendTo('head')
$('<script src="js/codemirror.js"></script>').appendTo('head')
$('<script src="js/modes/coffeescript.js"></script>').appendTo('head')
$('<script src="js/modes/ruby.js"></script>').appendTo('head')
$('<link rel="stylesheet" href="css/codemirror.css" />').appendTo('head')
$('<link rel="stylesheet" href="css/solarized.css" />').appendTo('head')

class window.Try extends Batman.App
	@dispatcher: false
	@navigator: false
	@layout: 'layout'

	@previewApp: ->
		if @previewWindow
			@previewWindow.focus()
		else
			@previewWindow = window.open('http://localhost:3000/?preview=true', "app_preview", "width=400,height=600")
			window.addEventListener 'message', (event) =>
				return unless event.data == 'previewReady'
				@sendPreviewData()

				console.log 'running'
				@previewWindow.postMessage('run', '*')
			, false

	@sendPreviewData: ->
		@sendPreviewFile('rdio.js.coffee')
		@sendPreviewDirectory('lib')
		@sendPreviewDirectory('controllers')
		@sendPreviewDirectory('models')
		@sendPreviewDirectory('views')
		@sendPreviewDirectory('html')

	@sendPreviewDirectory: (dir) ->
		dir = Try.File.findByPath("/app/assets/batman/#{dir}") if typeof dir is 'string'
		dir.get('childFiles').forEach (file) =>
			@sendPreviewFile(file)

	@sendPreviewFile: (file) ->
		file = Try.File.findByPath("/app/assets/batman/#{file}") if typeof file is 'string'
		@previewWindow.postMessage({file: file.toJSON()}, '*')

	@reloadPreview: ->
		return if not @previewWindow
		@previewWindow.postMessage('reload', '*')

class Try.LayoutView extends Batman.View
	constructor: (options) ->
		options.node = $('.intro')[0]
		super

	showFile: (file) ->
		if file.get('isDirectory')
			file.set('isExpanded', !file.get('isExpanded'))
		else
			@set 'currentFile', file
			file.show()

class Try.File extends Batman.Model
	@storageKey: 'app_files'
	@resourceName: 'app_files'

	@persist Batman.RailsStorage

	@findByName: (name) ->
		@get('loaded.indexedBy.name').get(name).get('first')

	@findByPath: (name) ->
		@get('loaded.indexedBy.id').get(name).get('first')

	@classAccessor 'topLevel', ->
		Try.File.get('all').filter (file) ->
			!file.get('parent')

	@accessor 'childFiles', ->
		files = new Batman.Set
		@get('children').forEach (child) ->
			if child.get('isDirectory')
				files.add(child.get('childFiles')._storage...)
			else
				files.add(child)

		files

	@encode 'name', 'content', 'isDirectory', 'id'
	@encode 'children',
		decode: (kids) ->
			set = new Batman.Set
			for kid in kids
				file = Try.File.createFromJSON(kid)
				file.set('parent', this)
				set.add(file)
			set

	isExpanded: false

	show: ->
		Try.set('currentFile', this)

class Try.CodeView extends Batman.View
	ready: ->
		# mode = if @get('name').indexOf('.coffee') != -1 then 'coffeescript' else 'ruby'
		mode = 'coffeescript'
		keys = {'Cmd-S': @save}

		node = @get('node')
		@cm = CodeMirror(node, theme: 'solarized', mode: mode, lineNumbers: true, extraKeys: keys)
		@cm.getWrapperElement().style.height = "100%"
		setTimeout =>
			@cm.refresh()
		, 0

		Try.observe 'currentFile', (file) =>
			@cm.setValue(file.get('content') || '')

	save: =>
		Try.set('currentFile.content', @cm.getValue())
		Try.reloadPreview()

class Try.FileView extends Batman.View
	html: """
		<a data-bind="file.name" data-event-click="showFile | withArguments file" class="file" data-addclass-directory="file.isDirectory" data-addclass-active="currentFile | equals file" data-addclass-expanded="file.isExpanded"></a>
		<ul data-showif="file.isDirectory | and file.isExpanded" data-renderif="file.isDirectory">
			<li data-foreach-file="file.children">
				<div data-view="FileView"></div>
			</li>
		</ul>
	"""

class Try.Step extends Batman.Object
	hasNext: true
	constructor: ->
		@set 'body', new Batman.Set
		Try.steps.add(this)

	activate: ->
		if @focus
			file = Try.File.findByPath(@focus)
			Try.layout.showFile(file)

		Try.set('currentStep', this)
		@start()

	start: ->

	next: ->
		array = steps.toArray()
		index = array.indexOf(this)
		step = array[index + 1]
		step.activate?()

class Try.ConsoleStep extends Try.Step
	isConsole: true

	start: ->
		$('#terminal-field').focus()

	@expect: (regex) ->
		this::regex = regex

	check: (value) ->
		if @regex.test(value)
			@next()

class Try.CodeStep extends Try.Step
	isCode: true

	start: ->
		if filename = @focusFile
			file = Try.File.findByName(filename)
			Try.layout.showFile(file)

		if filename = @options?.in
			file = Try.File.findByName(filename)
			file.observe 'value', (value) =>
				if @regex.test(value)
					@next()

	@expect: (regex, options) ->
		this::regex = regex
		this::options = options

	@focus: (name) ->
		this::focusFile = name

class Try.Tutorial
	title: (string) ->
		@step = new Try.Step
		@step.set('heading', string)

	say: (string) ->
		@step.get('body').add(string)

	focus: (filename) ->
		@step.focus = filename

	expect: ->

Try.File.load ->
	Try.set('steps', new Batman.Set)
	$.ajax url: 'tutorial.js', dataType: 'text', success: (content) ->
		eval("with(new Try.Tutorial){#{content}}")

		Try.run()
		Try.get('steps.first').activate()

		$('#terminal-field').on 'keydown', (e) ->
			if e.keyCode == 13
				Try.get('currentStep')?.check(@value)
