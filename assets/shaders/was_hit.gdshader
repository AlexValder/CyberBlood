shader_type canvas_item;

uniform vec4 tint : source_color;
uniform float mixture;

void fragment()
{
    vec4 tex = texture(TEXTURE, UV);
    COLOR.a = tex.a;
    COLOR.rgb = mix(tex.rgb, tint.rgb, mixture);
    COLOR.rgb = mix(tex.rgb, COLOR.rgb, floor(tex.a));
}