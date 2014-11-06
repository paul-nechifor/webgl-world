module.exports = class Plasma extends require '../ShaderWorld'
  constructor: (opts) ->
    startTime = Date.now()
    uniforms = time: {type: 'f', value: 0}
    tickFunc = -> uniforms.time.value = Date.now() - startTime

    shader = """
      uniform float time;
      varying vec2 vuv;
      void main() {
        float t = time / 10000.0;
        vec2 uv = 3.0 * vuv;
        float value = snoise(vec3(uv.x, uv.y, t / 2.0));
        float r = (sin(radians(value * 405.4)) + 1.0) / 2.0;
        r = r * 0.35 + 0.60;
        gl_FragColor = hsv_to_rgb(vec3(r, 1.0, 1.0));
      }
    """

    opts.uniforms or= uniforms
    opts.tickFunc or= tickFunc
    opts.fragmentShader or= [
      require '../shaders/snoise'
      require '../shaders/hsv_to_rgb'
      shader
    ].join '\n'

    super
