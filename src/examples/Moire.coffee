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
        vec2 uv = 5.0 * vuv;
        float value = snoise(vec3(uv.x, uv.y, t / 2.0));
        float r = (sin(radians(value * 4005.4)) + 1.0) / 2.0;
        r = floor(r * 2.0);
        gl_FragColor = vec4(r, r, r, 1.0);
      }
    """

    opts.uniforms or= uniforms
    opts.tickFunc or= tickFunc
    opts.fragmentShader or= [
      require '../shaders/snoise'
      shader
    ].join '\n'

    super
