-module(lustre@element@svg).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/lustre/element/svg.gleam").
-export([animate/1, animate_motion/1, animate_transform/1, mpath/1, set/1, circle/1, ellipse/1, line/1, polygon/1, polyline/1, rect/1, a/2, defs/2, g/2, marker/2, mask/2, missing_glyph/2, pattern/2, svg/2, switch/2, symbol/2, view/2, desc/2, metadata/2, title/2, filter/2, fe_blend/1, fe_color_matrix/1, fe_component_transfer/1, fe_composite/1, fe_convolve_matrix/1, fe_diffuse_lighting/2, fe_displacement_map/1, fe_drop_shadow/1, fe_flood/1, fe_func_a/1, fe_func_b/1, fe_func_g/1, fe_func_r/1, fe_gaussian_blur/1, fe_image/1, fe_merge/2, fe_merge_node/1, fe_morphology/1, fe_offset/1, fe_specular_lighting/2, fe_tile/2, fe_turbulence/1, linear_gradient/2, radial_gradient/2, stop/1, image/1, path/1, text/2, use_/1, fe_distant_light/1, fe_point_light/1, fe_spot_light/1, clip_path/2, script/2, style/2, foreign_object/2, text_path/2, tspan/2]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

-file("src/lustre/element/svg.gleam", 24).
?DOC("\n").
-spec animate(list(lustre@vdom@vattr:attribute(USA))) -> lustre@vdom@vnode:element(USA).
animate(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"animate"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 29).
?DOC("\n").
-spec animate_motion(list(lustre@vdom@vattr:attribute(USE))) -> lustre@vdom@vnode:element(USE).
animate_motion(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"animateMotion"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 34).
?DOC("\n").
-spec animate_transform(list(lustre@vdom@vattr:attribute(USI))) -> lustre@vdom@vnode:element(USI).
animate_transform(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"animateTransform"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 39).
?DOC("\n").
-spec mpath(list(lustre@vdom@vattr:attribute(USM))) -> lustre@vdom@vnode:element(USM).
mpath(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"mpath"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 44).
?DOC("\n").
-spec set(list(lustre@vdom@vattr:attribute(USQ))) -> lustre@vdom@vnode:element(USQ).
set(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"set"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 51).
?DOC("\n").
-spec circle(list(lustre@vdom@vattr:attribute(USU))) -> lustre@vdom@vnode:element(USU).
circle(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"circle"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 56).
?DOC("\n").
-spec ellipse(list(lustre@vdom@vattr:attribute(USY))) -> lustre@vdom@vnode:element(USY).
ellipse(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"ellipse"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 61).
?DOC("\n").
-spec line(list(lustre@vdom@vattr:attribute(UTC))) -> lustre@vdom@vnode:element(UTC).
line(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"line"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 66).
?DOC("\n").
-spec polygon(list(lustre@vdom@vattr:attribute(UTG))) -> lustre@vdom@vnode:element(UTG).
polygon(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"polygon"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 71).
?DOC("\n").
-spec polyline(list(lustre@vdom@vattr:attribute(UTK))) -> lustre@vdom@vnode:element(UTK).
polyline(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"polyline"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 76).
?DOC("\n").
-spec rect(list(lustre@vdom@vattr:attribute(UTO))) -> lustre@vdom@vnode:element(UTO).
rect(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"rect"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 83).
?DOC("\n").
-spec a(
    list(lustre@vdom@vattr:attribute(UTS)),
    list(lustre@vdom@vnode:element(UTS))
) -> lustre@vdom@vnode:element(UTS).
a(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"a"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/svg.gleam", 91).
?DOC("\n").
-spec defs(
    list(lustre@vdom@vattr:attribute(UTY)),
    list(lustre@vdom@vnode:element(UTY))
) -> lustre@vdom@vnode:element(UTY).
defs(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"defs"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/svg.gleam", 99).
?DOC("\n").
-spec g(
    list(lustre@vdom@vattr:attribute(UUE)),
    list(lustre@vdom@vnode:element(UUE))
) -> lustre@vdom@vnode:element(UUE).
g(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"g"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/svg.gleam", 107).
?DOC("\n").
-spec marker(
    list(lustre@vdom@vattr:attribute(UUK)),
    list(lustre@vdom@vnode:element(UUK))
) -> lustre@vdom@vnode:element(UUK).
marker(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"marker"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/svg.gleam", 115).
?DOC("\n").
-spec mask(
    list(lustre@vdom@vattr:attribute(UUQ)),
    list(lustre@vdom@vnode:element(UUQ))
) -> lustre@vdom@vnode:element(UUQ).
mask(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"mask"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/svg.gleam", 123).
?DOC("\n").
-spec missing_glyph(
    list(lustre@vdom@vattr:attribute(UUW)),
    list(lustre@vdom@vnode:element(UUW))
) -> lustre@vdom@vnode:element(UUW).
missing_glyph(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"missing-glyph"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/svg.gleam", 131).
?DOC("\n").
-spec pattern(
    list(lustre@vdom@vattr:attribute(UVC)),
    list(lustre@vdom@vnode:element(UVC))
) -> lustre@vdom@vnode:element(UVC).
pattern(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"pattern"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/svg.gleam", 139).
?DOC("\n").
-spec svg(
    list(lustre@vdom@vattr:attribute(UVI)),
    list(lustre@vdom@vnode:element(UVI))
) -> lustre@vdom@vnode:element(UVI).
svg(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"svg"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/svg.gleam", 147).
?DOC("\n").
-spec switch(
    list(lustre@vdom@vattr:attribute(UVO)),
    list(lustre@vdom@vnode:element(UVO))
) -> lustre@vdom@vnode:element(UVO).
switch(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"switch"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/svg.gleam", 155).
?DOC("\n").
-spec symbol(
    list(lustre@vdom@vattr:attribute(UVU)),
    list(lustre@vdom@vnode:element(UVU))
) -> lustre@vdom@vnode:element(UVU).
symbol(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"symbol"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/svg.gleam", 163).
?DOC("\n").
-spec view(
    list(lustre@vdom@vattr:attribute(UWA)),
    list(lustre@vdom@vnode:element(UWA))
) -> lustre@vdom@vnode:element(UWA).
view(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"view"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/svg.gleam", 173).
?DOC("\n").
-spec desc(
    list(lustre@vdom@vattr:attribute(UWG)),
    list(lustre@vdom@vnode:element(UWG))
) -> lustre@vdom@vnode:element(UWG).
desc(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"desc"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/svg.gleam", 181).
?DOC("\n").
-spec metadata(
    list(lustre@vdom@vattr:attribute(UWM)),
    list(lustre@vdom@vnode:element(UWM))
) -> lustre@vdom@vnode:element(UWM).
metadata(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"metadata"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/svg.gleam", 189).
?DOC("\n").
-spec title(
    list(lustre@vdom@vattr:attribute(UWS)),
    list(lustre@vdom@vnode:element(UWS))
) -> lustre@vdom@vnode:element(UWS).
title(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"title"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/svg.gleam", 199).
?DOC("\n").
-spec filter(
    list(lustre@vdom@vattr:attribute(UWY)),
    list(lustre@vdom@vnode:element(UWY))
) -> lustre@vdom@vnode:element(UWY).
filter(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"filter"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/svg.gleam", 207).
?DOC("\n").
-spec fe_blend(list(lustre@vdom@vattr:attribute(UXE))) -> lustre@vdom@vnode:element(UXE).
fe_blend(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feBlend"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 212).
?DOC("\n").
-spec fe_color_matrix(list(lustre@vdom@vattr:attribute(UXI))) -> lustre@vdom@vnode:element(UXI).
fe_color_matrix(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feColorMatrix"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 217).
?DOC("\n").
-spec fe_component_transfer(list(lustre@vdom@vattr:attribute(UXM))) -> lustre@vdom@vnode:element(UXM).
fe_component_transfer(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feComponentTransfer"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 222).
?DOC("\n").
-spec fe_composite(list(lustre@vdom@vattr:attribute(UXQ))) -> lustre@vdom@vnode:element(UXQ).
fe_composite(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feComposite"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 227).
?DOC("\n").
-spec fe_convolve_matrix(list(lustre@vdom@vattr:attribute(UXU))) -> lustre@vdom@vnode:element(UXU).
fe_convolve_matrix(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feConvolveMatrix"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 232).
?DOC("\n").
-spec fe_diffuse_lighting(
    list(lustre@vdom@vattr:attribute(UXY)),
    list(lustre@vdom@vnode:element(UXY))
) -> lustre@vdom@vnode:element(UXY).
fe_diffuse_lighting(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feDiffuseLighting"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/svg.gleam", 240).
?DOC("\n").
-spec fe_displacement_map(list(lustre@vdom@vattr:attribute(UYE))) -> lustre@vdom@vnode:element(UYE).
fe_displacement_map(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feDisplacementMap"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 245).
?DOC("\n").
-spec fe_drop_shadow(list(lustre@vdom@vattr:attribute(UYI))) -> lustre@vdom@vnode:element(UYI).
fe_drop_shadow(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feDropShadow"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 250).
?DOC("\n").
-spec fe_flood(list(lustre@vdom@vattr:attribute(UYM))) -> lustre@vdom@vnode:element(UYM).
fe_flood(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feFlood"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 255).
?DOC("\n").
-spec fe_func_a(list(lustre@vdom@vattr:attribute(UYQ))) -> lustre@vdom@vnode:element(UYQ).
fe_func_a(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feFuncA"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 260).
?DOC("\n").
-spec fe_func_b(list(lustre@vdom@vattr:attribute(UYU))) -> lustre@vdom@vnode:element(UYU).
fe_func_b(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feFuncB"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 265).
?DOC("\n").
-spec fe_func_g(list(lustre@vdom@vattr:attribute(UYY))) -> lustre@vdom@vnode:element(UYY).
fe_func_g(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feFuncG"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 270).
?DOC("\n").
-spec fe_func_r(list(lustre@vdom@vattr:attribute(UZC))) -> lustre@vdom@vnode:element(UZC).
fe_func_r(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feFuncR"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 275).
?DOC("\n").
-spec fe_gaussian_blur(list(lustre@vdom@vattr:attribute(UZG))) -> lustre@vdom@vnode:element(UZG).
fe_gaussian_blur(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feGaussianBlur"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 280).
?DOC("\n").
-spec fe_image(list(lustre@vdom@vattr:attribute(UZK))) -> lustre@vdom@vnode:element(UZK).
fe_image(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feImage"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 285).
?DOC("\n").
-spec fe_merge(
    list(lustre@vdom@vattr:attribute(UZO)),
    list(lustre@vdom@vnode:element(UZO))
) -> lustre@vdom@vnode:element(UZO).
fe_merge(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feMerge"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/svg.gleam", 293).
?DOC("\n").
-spec fe_merge_node(list(lustre@vdom@vattr:attribute(UZU))) -> lustre@vdom@vnode:element(UZU).
fe_merge_node(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feMergeNode"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 298).
?DOC("\n").
-spec fe_morphology(list(lustre@vdom@vattr:attribute(UZY))) -> lustre@vdom@vnode:element(UZY).
fe_morphology(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feMorphology"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 303).
?DOC("\n").
-spec fe_offset(list(lustre@vdom@vattr:attribute(VAC))) -> lustre@vdom@vnode:element(VAC).
fe_offset(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feOffset"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 308).
?DOC("\n").
-spec fe_specular_lighting(
    list(lustre@vdom@vattr:attribute(VAG)),
    list(lustre@vdom@vnode:element(VAG))
) -> lustre@vdom@vnode:element(VAG).
fe_specular_lighting(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feSpecularLighting"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/svg.gleam", 316).
?DOC("\n").
-spec fe_tile(
    list(lustre@vdom@vattr:attribute(VAM)),
    list(lustre@vdom@vnode:element(VAM))
) -> lustre@vdom@vnode:element(VAM).
fe_tile(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feTile"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/svg.gleam", 324).
?DOC("\n").
-spec fe_turbulence(list(lustre@vdom@vattr:attribute(VAS))) -> lustre@vdom@vnode:element(VAS).
fe_turbulence(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feTurbulence"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 331).
?DOC("\n").
-spec linear_gradient(
    list(lustre@vdom@vattr:attribute(VAW)),
    list(lustre@vdom@vnode:element(VAW))
) -> lustre@vdom@vnode:element(VAW).
linear_gradient(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"linearGradient"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/svg.gleam", 339).
?DOC("\n").
-spec radial_gradient(
    list(lustre@vdom@vattr:attribute(VBC)),
    list(lustre@vdom@vnode:element(VBC))
) -> lustre@vdom@vnode:element(VBC).
radial_gradient(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"radialGradient"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/svg.gleam", 347).
?DOC("\n").
-spec stop(list(lustre@vdom@vattr:attribute(VBI))) -> lustre@vdom@vnode:element(VBI).
stop(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"stop"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 354).
?DOC("\n").
-spec image(list(lustre@vdom@vattr:attribute(VBM))) -> lustre@vdom@vnode:element(VBM).
image(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"image"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 359).
?DOC("\n").
-spec path(list(lustre@vdom@vattr:attribute(VBQ))) -> lustre@vdom@vnode:element(VBQ).
path(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"path"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 364).
?DOC("\n").
-spec text(list(lustre@vdom@vattr:attribute(VBU)), binary()) -> lustre@vdom@vnode:element(VBU).
text(Attrs, Content) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"text"/utf8>>,
        Attrs,
        [lustre@element:text(Content)]
    ).

-file("src/lustre/element/svg.gleam", 369).
?DOC("\n").
-spec use_(list(lustre@vdom@vattr:attribute(VBY))) -> lustre@vdom@vnode:element(VBY).
use_(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"use"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 376).
?DOC("\n").
-spec fe_distant_light(list(lustre@vdom@vattr:attribute(VCC))) -> lustre@vdom@vnode:element(VCC).
fe_distant_light(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feDistantLight"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 381).
?DOC("\n").
-spec fe_point_light(list(lustre@vdom@vattr:attribute(VCG))) -> lustre@vdom@vnode:element(VCG).
fe_point_light(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"fePointLight"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 386).
?DOC("\n").
-spec fe_spot_light(list(lustre@vdom@vattr:attribute(VCK))) -> lustre@vdom@vnode:element(VCK).
fe_spot_light(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feSpotLight"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 393).
?DOC("\n").
-spec clip_path(
    list(lustre@vdom@vattr:attribute(VCO)),
    list(lustre@vdom@vnode:element(VCO))
) -> lustre@vdom@vnode:element(VCO).
clip_path(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"clipPath"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/svg.gleam", 401).
?DOC("\n").
-spec script(list(lustre@vdom@vattr:attribute(VCU)), binary()) -> lustre@vdom@vnode:element(VCU).
script(Attrs, Js) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"script"/utf8>>,
        Attrs,
        [lustre@element:text(Js)]
    ).

-file("src/lustre/element/svg.gleam", 406).
?DOC("\n").
-spec style(list(lustre@vdom@vattr:attribute(VCY)), binary()) -> lustre@vdom@vnode:element(VCY).
style(Attrs, Css) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"style"/utf8>>,
        Attrs,
        [lustre@element:text(Css)]
    ).

-file("src/lustre/element/svg.gleam", 413).
?DOC("\n").
-spec foreign_object(
    list(lustre@vdom@vattr:attribute(VDC)),
    list(lustre@vdom@vnode:element(VDC))
) -> lustre@vdom@vnode:element(VDC).
foreign_object(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"foreignObject"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/svg.gleam", 421).
?DOC("\n").
-spec text_path(
    list(lustre@vdom@vattr:attribute(VDI)),
    list(lustre@vdom@vnode:element(VDI))
) -> lustre@vdom@vnode:element(VDI).
text_path(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"textPath"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/svg.gleam", 429).
?DOC("\n").
-spec tspan(
    list(lustre@vdom@vattr:attribute(VDO)),
    list(lustre@vdom@vnode:element(VDO))
) -> lustre@vdom@vnode:element(VDO).
tspan(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"tspan"/utf8>>,
        Attrs,
        Children
    ).
