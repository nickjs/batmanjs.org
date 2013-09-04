###
# try.coffee
# Powers the tutorial for batmanjs.org
# This code is pretty much a clusterfuck of hacks
# ... Sorry? <3 Nick
###

if window.location.host.indexOf('localhost') != -1
  APP_URL = 'http://localhost:3000'
else
  APP_URL = 'http://batmanrdio.herokuapp.com'

class window.Try extends Batman.App
  @dispatcher: false
  @navigator: false
  @layout: 'layout'

  @previewApp: ->
    if @previewWindow and !@previewWindow.closed
      @previewWindow.focus()
    else
      @previewWindow = window.open("#{APP_URL}/?preview=true", "app_preview", "width=400,height=600")
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
    return if dir.get('isHidden')

    dir.get('childFiles').forEach (file) =>
      @sendPreviewFile(file)

  @sendPreviewFile: (file) ->
    file = Try.File.findByPath("/app/assets/batman/#{file}") if typeof file is 'string'
    return if file.get('isHidden')

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
      file.show()

  nextStep: ->
    index = Try.steps.indexOf(Try.currentStep)
    step = Try.steps[index + 1]
    step?.activate()

  completeStep: ->
    Try.currentStep.complete()

class Try.File extends Batman.Model
  @storageKey: 'app_files'
  @resourceName: 'files'

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
    decode: (kids, key, _, __, parent) ->
      set = new Batman.Set
      for kid in kids
        file = Try.File.createFromJSON(kid)
        file.set('parent', parent)
        set.add(file)

      return set

  @encode 'expectations',
    decode: (expectations, key, data) ->
      for expectation in expectations
        Try.namedSteps[expectation.stepName]?[expectation.action]?(data.id, new RegExp(expectation.regex), expectation.completion)

      return null

  isExpanded: false

  show: ->
    Try.set('currentFile', this)

class Try.CodeView extends Batman.View
  EXTENSIONS = {
    '.html.erb': 'application/x-erb'
    '.html': 'text/html'
    '.coffee': 'coffeescript'
    '.js': 'coffeescript'
    '.js.coffee': 'coffeescript'
    '.rb': 'ruby'
    '.ru': 'ruby'
    '.css': 'css'
    '.css.scss': 'css'
    'Gemfile': 'ruby'
  }

  modeForFile: (file) ->
    filename = file.get('id')

    for ext, mode of EXTENSIONS when filename.indexOf(ext) != -1
      return mode

  docForFile: (file) ->
    filename = file.get('id')

    @docs ||= {}
    if not (doc = @docs[filename])
      @set('expectChanges', filename.indexOf('.rb') == -1)

      doc = @docs[filename] = CodeMirror.Doc(file.get('content'), @modeForFile(file))
      file.observe 'content', (value) ->
        doc.setValue(value) if value != doc.getValue()

    return doc

  ready: ->
    keys = {'Cmd-S': @save, 'Ctrl-S': @save}

    node = @get('node')
    @cm = CodeMirror(node, theme: 'solarized', lineNumbers: true, extraKeys: keys)
    @cm.getWrapperElement().style.height = "100%"

    Try.observeAndFire 'currentFile', (file) =>
      setTimeout =>
        @cm.swapDoc(@docForFile(file)) if file
        @cm.setOption('readOnly', !file || !@get('expectChanges'))
        @cm.refresh()
      , 0

    Try.observe 'currentStep', (step) =>
      if step instanceof Try.CodeStep
        setTimeout =>
          @cm.refresh()
        , 0

  save: =>
    Try.set('currentFile.content', @cm.getValue())
    Try.reloadPreview()

    Try.fire('fileSaved', Try.get('currentFile'))

class Try.FileView extends Batman.View
  html: """
    <a data-bind="file.name" data-hideif="file.isHidden" data-event-click="showFile | withArguments file" class="file" data-addclass-directory="file.isDirectory" data-addclass-active="currentFile | equals file" data-addclass-expanded="file.isExpanded"></a>
    <ul data-showif="file.isDirectory | and file.isExpanded" data-renderif="file.isDirectory">
      <li data-foreach-file="file.children.sortedBy.isDirectory">
        <div data-view="FileView"></div>
      </li>
    </ul>
  """

class Try.Step extends Batman.Object
  hasNextStep: true

  constructor: (@name, showFiles, block) ->
    if !block
      block = showFiles
      showFiles = null

    @body = new Batman.Set
    @afterBody = new Batman.Set

    @fileAppearances = showFiles

    Try.namedSteps[name] = this
    Try.steps.push(this)
    block.call(this)

  activate: ->
    Try.set('currentStep', this)
    Try.set('showLaunchAppButton', true) if @enablesLaunchAppButton
    Try.reloadPreview() if @reloadsPreview

    if @fileAppearances
      for filename in @fileAppearances
        Try.File.findByPath(filename).set('isHidden', false)

    for filename, matches of @appearances
      file = Try.File.findByPath(filename)
      for match in matches
        value = file.get('content')
        if !match.regex.test(value)
          completion = match.completion
          newString = value.substr(0, completion.index)
          newString += completion.value
          newString += value.substr(completion.index)
          file.set('content', newString)

    return

  title: (string) ->
    @set('heading', string)

  say: (string) ->
    string = string.replace(/`(.*?)`/g, "<code>$1</code>")
    @get('body').add(string)

  after: (string) ->
    string = string.replace(/`(.*?)`/g, "<code>$1</code>")
    @get('afterBody').add(string)

  appear: (filename, regex, completion) ->
    @appearances ||= {}
    (@appearances[filename] ||= []).push({regex, completion})

  complete: ->
    return if @isComplete
    @set('isComplete', true)
    @afterComplete()

  afterComplete: ->
    @set('body', @afterBody) if @afterBody.get('length')

  @accessor 'showNextStepButton', ->
    @get('hasNextStep') and @get('isComplete')

  enableLaunchAppButton: ->
    @enablesLaunchAppButton = true

  reloadPreview: ->
    @reloadsPreview = true

class Try.ConsoleStep extends Try.Step
  isConsole: true

  activate: ->
    super
    $('#terminal-field').val('').attr('disabled', false).focus()

  expect: (@regex, @result) ->

  check: (value) ->
    if @regex.test(value)
      @set('isError', false)
      @set('isComplete', true)
      @afterComplete()

      $('#terminal-field').attr('disabled', true)
    else
      @set('isError', true)

class Try.CodeStep extends Try.Step
  isCode: true

  activate: ->
    if filename = @focusFile
      file = Try.File.findByPath(filename)
      Try.layout.showFile(file)

      file.set('isExpanded', true) while file = file.get('parent')

    super

  expect: (filename, regex, completion) ->
    @matches ||= {}
    (@matches[filename] ||= []).push({regex, completion})

  focus: (filename) ->
    @focusFile = filename

  complete: ->
    return if @isComplete

    for filename, matches of @matches
      file = Try.File.findByPath(filename)
      for match in matches
        value = file.get('content')
        if !match.regex.test(value)
          completion = match.completion
          newString = value.substr(0, completion.index)
          newString += completion.value
          newString += value.substr(completion.index)
          file.set('content', newString)

    super


class Try.Tutorial
  constructor: ->
    Try.steps = []
    Try.namedSteps = {}
    Try.on 'fileSaved', (file) =>
      for filename, matches of Try.currentStep.matches
        file = Try.File.findByPath(filename)
        value = file.get('content')
        for match in matches
          if !match.regex.test(value)
            return

      Try.currentStep.set('isComplete', true)
      Try.currentStep.afterComplete()

  c: (name, showFiles, block) ->
    new Try.CodeStep(name, showFiles, block)

  $: (name, showFiles, block) ->
    new Try.ConsoleStep(name, showFiles, block)

Try.initializeTutorial = (tutorialContent, callback) ->
  eval("with(new Try.Tutorial){#{tutorialContent}}")

  Try.File.load ->
    for step in Try.steps
      if step.fileAppearances
        for file in step.fileAppearances
          Try.File.findByPath(file).set('isHidden', true)

    Try.run()
    Try.steps[0].activate()

    window.onbeforeunload = ->
      "Are you sure you want to navigate away? Your app will be lost in the abyss, as we're not cool enough to save your changes in localStorage yet."

    $('#terminal-field').on 'keydown', (e) ->
      if e.keyCode == 13
        Try.get('currentStep')?.check(@value)

    callback?()
