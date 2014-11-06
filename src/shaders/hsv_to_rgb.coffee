module.exports = """
  vec4 hsv_to_rgb(vec3 hsv) {
      vec4 color = vec4(0.0, 0.0, 0.0, 0.0);
      float f,p,q,t, h,s,v;
      float r = 0.0, g = 0.0, b = 0.0, i;

      if(hsv[1] == 0.0) {
          if(hsv[2] != 0.0) {
              color = vec4(hsv[2]);        // black and white case
          }
      } else {      // this next step is flawed if the texels are 8 bit!!
          h = hsv.x * 360.0;
          s = hsv.y;
          v = hsv.z;
          if(h == 360.0) {
              h = 0.0;
          }

          h /= 60.0;
          i = floor(h);
          f = h-i;
          p = v * (1.0 - s);
          q = v * (1.0 -(s * f));
          t = v * (1.0 -(s * (1.0 -f)));
          if( i == 0.0)        {             r = v;            g  = t; b = p; }
          else if( i== 1.0 )   {             r = q;            g  = v; b = p; }
          else if( i== 2.0 )   {             r = p;            g  = v; b = t; }
          else if( i== 3.0 )   {             r = p;            g  = q; b = v; }
          else if( i== 4.0 )   {             r = t;            g  = p; b = v; }
          else if( i== 5.0 )   {             r = v;            g  = p; b = q; }
          color.r = r;        color.g = g;         color.b = b;
      }
      return color;
  }
"""
