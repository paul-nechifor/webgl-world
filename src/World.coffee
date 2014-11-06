WorldView = require './WorldView'

module.exports = class World
  constructor: (viewOpts) ->
    @worldView = new WorldView @, viewOpts or {}
    @renderer = null
    @scene = null
    @camera = null

  start: ->
    @setupWorld()
    @worldView.setupView()
    @startTick()

  setupWorld: ->
    throw new 'Not implemented.'

  startTick: ->
    tick = @onTick.bind @
    next = =>
      tick()
      @renderer.render @scene, @camera
      requestAnimationFrame next
    next()

  onTick: ->
    throw new 'Not implemented.'

  onUpdateSize: (width, height) ->
    throw new 'Not implemented.'
