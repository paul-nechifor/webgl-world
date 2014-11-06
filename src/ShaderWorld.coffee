World = require './World'
util = require './util'

defaultVertexShader = """
  varying vec2 vuv;
  void main() {
    vec4 mvPosition = modelViewMatrix * vec4(position, 1.0);
    gl_Position = projectionMatrix * mvPosition;
    vuv = uv;
  }
"""

module.exports = class ShaderWorld extends World
  constructor: (opts) ->
    super @, opts.viewOpts
    @vertexShader = opts.vertexShader or defaultVertexShader
    @uniforms = opts.uniforms
    @fragmentShader = opts.fragmentShader
    @tickFunc = opts.tickFunc

  setupWorld: ->
    @renderer = new THREE.WebGLRenderer()
    @scene = new THREE.Scene()
    @camera = new THREE.OrthographicCamera -1, 1, 1, -1, -1, 1
    @scene.add @camera
    material = new THREE.ShaderMaterial
      uniforms: @uniforms
      vertexShader: @vertexShader
      fragmentShader: @fragmentShader
    mesh = new THREE.Mesh new THREE.PlaneGeometry(2, 2), material
    @scene.add mesh

  onTick: ->
    @tickFunc()

  onUpdateSize: (width, height) ->
    util.updateBasicOrtoCamera @camera, width, height
