module.exports = class WorldView
  constructor: (@world, opts) ->
    @element = opts.element or document.body
    @fullscreen = opts.fullscreen or true
    @width = opts.width or 200
    @height = opts.height or 200
    @onResizeListener = null

  setupView: ->
    s = @element.style
    s.backgroundColor = "#000"
    s.overflow = "hidden"
    s.margin = "0"
    canvas = @world.renderer.domElement
    @element.appendChild canvas

    # Who's the fucking wise guy who came up with the idea that canvas should
    # be an inline-block so that it has ghost margins?
    canvas.style.display = 'block'
    @updateFullscreen @fullscreen
    @updateSize @width, @height

  updateSize: (@width, @height) ->
    @world.renderer.setSize @width, @height
    @world.onUpdateSize @width, @height

  updateFullscreen: (@fullscreen) ->
    style = @element.style
    if @fullscreen
      return if @onResizeListener isnt null
      style.position = "fixed"
      style.left = "0"
      style.top = "0"
      that = this
      @onResizeListener = ->
        that.updateSize window.innerWidth, window.innerHeight
      @onResizeListener()
      window.addEventListener "resize", @onResizeListener
    else
      return if @onResizeListener is null
      style.position = "relative"
      window.removeEventListener "resize", @onResizeListener
      @onResizeListener = null
    return
