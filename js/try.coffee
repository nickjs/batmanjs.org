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

	previewApp: ->
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

	sendPreviewData: ->
		@sendPreviewFile('rdio.js.coffee')
		@sendPreviewDirectory('lib')
		@sendPreviewDirectory('controllers')
		@sendPreviewDirectory('models')
		@sendPreviewDirectory('views')
		@sendPreviewDirectory('html')

	sendPreviewDirectory: (dirname) ->
		dir = Try.File.findByPath("/app/assets/batman/#{dirname}")
		dir.get('childFiles').forEach (file) =>
			@previewWindow.postMessage({file: file.toJSON()}, '*')

	sendPreviewFile: (filename) ->
		file = Try.File.findByPath("/app/assets/batman/#{filename}")
		@previewWindow.postMessage({file: file.toJSON()}, '*')

class Try.File extends Batman.Model
	@storageKey: 'app_files'
	@resourceName: 'app_files'

	@persist Batman.RailsStorage

	@findByName: (name) ->
		@get('loaded.indexedBy.name').get(name).get('first')

	@findByPath: (name) ->
		@get('loaded.indexedBy.id').get(name).get('first')

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
				set.add(Try.File.createFromJSON(kid))
			set

	isExpanded: false

	show: ->
		if !@cm
			mode = if @get('name').indexOf('.coffee') != -1 then 'coffeescript' else 'ruby'
			keys = {'Cmd-S': => @save() }

			@node = $('<div style="height:100%"></div>')
			@cm = CodeMirror(@node[0], theme: 'solarized', mode: mode, lineNumbers: true, extraKeys: keys)
			@cm.getWrapperElement().style.height = "100%"
			setTimeout =>
				@cm.refresh()
			, 0

		@cm.setValue(@get('content') || '')
		$('#code-editor').html('').append(@node)

	save: ->
		@set('value', @cm.getValue())

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
	activate: ->
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

class Try.GemfileStep extends Try.CodeStep
	heading: "Welcome to Batman!"
	body: "Let's build an app. We've created a brand new Rails app for you."
	task: "Start off by adding `batman-rails` to your gemfile, and press Cmd+S when you're done."

	@expect /gem\s*[\"|\']batman\-rails[\"|\']/, in: 'Gemfile'
	@focus 'Gemfile'

class Try.GenerateAppStep extends Try.ConsoleStep
	heading: "Great! We've run `bundle install` for you."
	body: "Now, let's create a new batman application inside your rails app."
	task: "Run `rails generate batman:app` from the console, and press enter to submit the command."

	@expect /rails\s*[g|generate]\s*batman:app/

class Try.ExploreStep extends Try.CodeStep
	heading: "And there's your app!"
	body: "Take a moment to explore through the directory structure."
	task: "When you're ready, click Next Step."

	@focus 'app'

class Try.GenerateScaffold extends Try.ConsoleStep
	heading: "Let's generate our first resource."
	body: "We'll need to fetch some artists from our Rdio API."
	task: "Type `rails g batman:scaffold Artist` to make a new scaffold."

	@expect /rails\s*[g|generate]\s*batman:scaffold\s*Artist/

class Try.FinalStep extends Try.Step
	heading: "That's all for now, more soon!"
	body: "<a href='/batman-rdio.zip'>Click here</a> to download your app."
	hasNext: false

steps = new Batman.Set(
	new Try.GemfileStep
	new Try.GenerateAppStep
	new Try.ExploreStep
	new Try.GenerateScaffold
	new Try.FinalStep
)

Try.set('steps', steps)
Try.File.load ->
	Try.run()
	steps.get('first').activate()

	$('#terminal-field').on 'keydown', (e) ->
		if e.keyCode == 13
			Try.get('currentStep')?.check(@value)
