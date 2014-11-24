class Head
  constructor: ->
    material = new THREE.MeshBasicMaterial map: Head.texture
    @mesh = new THREE.Mesh Head.geometry, material
    @mesh.rotation.y = Math.PI
    @mesh.scale.set 0.1, 0.1, 0.1
    @mesh.position.x = Math.random() * 1000 - 500
    @mesh.position.y = Math.random() * 1000 - 500
    @mesh.position.z = Math.random() * -2000
    @speed = 0.5 + Math.random() * 0.2
    @angle = Math.random() * 2 * Math.PI

  @loadResources = (pathPrefix, cb) ->
    Head.texture = THREE.ImageUtils.loadTexture pathPrefix + '/paul.jpg'
    loader = new THREE.OBJLoader
    loader.load pathPrefix + '/paul.obj', (object) ->
      Head.geometry = object.children[0].geometry
      cb()

  tick: (time, delta) ->
    pos = @mesh.position
    pos.z += @speed * delta
    pos.z = -2000 if pos.z > 0
    @mesh.rotation.y = Math.PI + Math.PI / 8 * Math.sin @angle + time * 0.0015

module.exports = class Disapproval extends require '../ShaderWorld'
  constructor: ->
    super
    @heads = []

  @loadResources = (pathPrefix, cb) ->
    Head.loadResources pathPrefix, cb

  setupWorld: ->
    @renderer = new THREE.WebGLRenderer
    @renderer.setClearColorHex 0xe8caae, 1
    @scene = new THREE.Scene
    @scene.fog = new THREE.FogExp2 0xefd1b5, 0.0009
    ratio = @worldView.width / @worldView.height
    @camera = new THREE.PerspectiveCamera 40, ratio, 1, 4000
    @scene.add @camera
    @addObjects()
    @startTime = Date.now()
    @lastTime = Date.now()

  addObjects: ->
    ambient = new THREE.AmbientLight 0x101030
    @scene.add ambient
    directionalLight = new THREE.DirectionalLight 0xffeedd
    directionalLight.position.set(0, 0, 1).normalize()
    @scene.add directionalLight
    i = 0
    while i < 100
      head = new Head
      @scene.add head.mesh
      @heads.push head
      i++
    return

  onTick: ->
    now = Date.now()
    time = now - @startTime
    delta = now - @lastTime
    @lastTime = now
    i = 0
    len = @heads.length
    while i < len
      @heads[i].tick time, delta
      i++
    return

  onUpdateSize: (width, height) ->
    @camera.aspect = width / height
    @camera.updateProjectionMatrix()
