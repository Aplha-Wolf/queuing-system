-module(lustre@element@mathml).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/lustre/element/mathml.gleam").
-export([merror/2, mphantom/2, mprescripts/2, mrow/2, mstyle/2, semantics/2, mmultiscripts/2, mover/2, msub/2, msubsup/2, msup/2, munder/2, munderover/2, mroot/2, msqrt/2, annotation/2, annotation_xml/2, mfrac/2, mn/2, mo/2, mi/2, mpadded/2, ms/2, mspace/1, mtable/2, mtd/2, mtext/2, mtr/2]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

-file("src/lustre/element/mathml.gleam", 23).
?DOC("\n").
-spec merror(
    list(lustre@vdom@vattr:attribute(WOE)),
    list(lustre@vdom@vnode:element(WOE))
) -> lustre@vdom@vnode:element(WOE).
merror(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"merror"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/mathml.gleam", 31).
?DOC("\n").
-spec mphantom(
    list(lustre@vdom@vattr:attribute(WOK)),
    list(lustre@vdom@vnode:element(WOK))
) -> lustre@vdom@vnode:element(WOK).
mphantom(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"mphantom"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/mathml.gleam", 39).
?DOC("\n").
-spec mprescripts(
    list(lustre@vdom@vattr:attribute(WOQ)),
    list(lustre@vdom@vnode:element(WOQ))
) -> lustre@vdom@vnode:element(WOQ).
mprescripts(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"mprescripts"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/mathml.gleam", 47).
?DOC("\n").
-spec mrow(
    list(lustre@vdom@vattr:attribute(WOW)),
    list(lustre@vdom@vnode:element(WOW))
) -> lustre@vdom@vnode:element(WOW).
mrow(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"mrow"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/mathml.gleam", 55).
?DOC("\n").
-spec mstyle(
    list(lustre@vdom@vattr:attribute(WPC)),
    list(lustre@vdom@vnode:element(WPC))
) -> lustre@vdom@vnode:element(WPC).
mstyle(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"mstyle"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/mathml.gleam", 63).
?DOC("\n").
-spec semantics(
    list(lustre@vdom@vattr:attribute(WPI)),
    list(lustre@vdom@vnode:element(WPI))
) -> lustre@vdom@vnode:element(WPI).
semantics(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"semantics"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/mathml.gleam", 73).
?DOC("\n").
-spec mmultiscripts(
    list(lustre@vdom@vattr:attribute(WPO)),
    list(lustre@vdom@vnode:element(WPO))
) -> lustre@vdom@vnode:element(WPO).
mmultiscripts(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"mmultiscripts"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/mathml.gleam", 81).
?DOC("\n").
-spec mover(
    list(lustre@vdom@vattr:attribute(WPU)),
    list(lustre@vdom@vnode:element(WPU))
) -> lustre@vdom@vnode:element(WPU).
mover(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"mover"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/mathml.gleam", 89).
?DOC("\n").
-spec msub(
    list(lustre@vdom@vattr:attribute(WQA)),
    list(lustre@vdom@vnode:element(WQA))
) -> lustre@vdom@vnode:element(WQA).
msub(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"msub"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/mathml.gleam", 97).
?DOC("\n").
-spec msubsup(
    list(lustre@vdom@vattr:attribute(WQG)),
    list(lustre@vdom@vnode:element(WQG))
) -> lustre@vdom@vnode:element(WQG).
msubsup(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"msubsup"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/mathml.gleam", 105).
?DOC("\n").
-spec msup(
    list(lustre@vdom@vattr:attribute(WQM)),
    list(lustre@vdom@vnode:element(WQM))
) -> lustre@vdom@vnode:element(WQM).
msup(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"msup"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/mathml.gleam", 113).
?DOC("\n").
-spec munder(
    list(lustre@vdom@vattr:attribute(WQS)),
    list(lustre@vdom@vnode:element(WQS))
) -> lustre@vdom@vnode:element(WQS).
munder(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"munder"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/mathml.gleam", 121).
?DOC("\n").
-spec munderover(
    list(lustre@vdom@vattr:attribute(WQY)),
    list(lustre@vdom@vnode:element(WQY))
) -> lustre@vdom@vnode:element(WQY).
munderover(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"munderover"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/mathml.gleam", 131).
?DOC("\n").
-spec mroot(
    list(lustre@vdom@vattr:attribute(WRE)),
    list(lustre@vdom@vnode:element(WRE))
) -> lustre@vdom@vnode:element(WRE).
mroot(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"mroot"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/mathml.gleam", 139).
?DOC("\n").
-spec msqrt(
    list(lustre@vdom@vattr:attribute(WRK)),
    list(lustre@vdom@vnode:element(WRK))
) -> lustre@vdom@vnode:element(WRK).
msqrt(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"msqrt"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/mathml.gleam", 149).
?DOC("\n").
-spec annotation(
    list(lustre@vdom@vattr:attribute(WRQ)),
    list(lustre@vdom@vnode:element(WRQ))
) -> lustre@vdom@vnode:element(WRQ).
annotation(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"annotation"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/mathml.gleam", 157).
?DOC("\n").
-spec annotation_xml(
    list(lustre@vdom@vattr:attribute(WRW)),
    list(lustre@vdom@vnode:element(WRW))
) -> lustre@vdom@vnode:element(WRW).
annotation_xml(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"annotation-xml"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/mathml.gleam", 165).
?DOC("\n").
-spec mfrac(
    list(lustre@vdom@vattr:attribute(WSC)),
    list(lustre@vdom@vnode:element(WSC))
) -> lustre@vdom@vnode:element(WSC).
mfrac(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"mfrac"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/mathml.gleam", 173).
?DOC("\n").
-spec mn(list(lustre@vdom@vattr:attribute(WSI)), binary()) -> lustre@vdom@vnode:element(WSI).
mn(Attrs, Text) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"mn"/utf8>>,
        Attrs,
        [lustre@element:text(Text)]
    ).

-file("src/lustre/element/mathml.gleam", 178).
?DOC("\n").
-spec mo(list(lustre@vdom@vattr:attribute(WSM)), binary()) -> lustre@vdom@vnode:element(WSM).
mo(Attrs, Text) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"mo"/utf8>>,
        Attrs,
        [lustre@element:text(Text)]
    ).

-file("src/lustre/element/mathml.gleam", 183).
?DOC("\n").
-spec mi(list(lustre@vdom@vattr:attribute(WSQ)), binary()) -> lustre@vdom@vnode:element(WSQ).
mi(Attrs, Text) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"mi"/utf8>>,
        Attrs,
        [lustre@element:text(Text)]
    ).

-file("src/lustre/element/mathml.gleam", 188).
?DOC("\n").
-spec mpadded(
    list(lustre@vdom@vattr:attribute(WSU)),
    list(lustre@vdom@vnode:element(WSU))
) -> lustre@vdom@vnode:element(WSU).
mpadded(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"mpadded"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/mathml.gleam", 196).
?DOC("\n").
-spec ms(list(lustre@vdom@vattr:attribute(WTA)), binary()) -> lustre@vdom@vnode:element(WTA).
ms(Attrs, Text) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"ms"/utf8>>,
        Attrs,
        [lustre@element:text(Text)]
    ).

-file("src/lustre/element/mathml.gleam", 201).
?DOC("\n").
-spec mspace(list(lustre@vdom@vattr:attribute(WTE))) -> lustre@vdom@vnode:element(WTE).
mspace(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"mspace"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/mathml.gleam", 206).
?DOC("\n").
-spec mtable(
    list(lustre@vdom@vattr:attribute(WTI)),
    list(lustre@vdom@vnode:element(WTI))
) -> lustre@vdom@vnode:element(WTI).
mtable(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"mtable"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/mathml.gleam", 214).
?DOC("\n").
-spec mtd(
    list(lustre@vdom@vattr:attribute(WTO)),
    list(lustre@vdom@vnode:element(WTO))
) -> lustre@vdom@vnode:element(WTO).
mtd(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"mtd"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/mathml.gleam", 222).
?DOC("\n").
-spec mtext(list(lustre@vdom@vattr:attribute(WTU)), binary()) -> lustre@vdom@vnode:element(WTU).
mtext(Attrs, Text) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"mtext"/utf8>>,
        Attrs,
        [lustre@element:text(Text)]
    ).

-file("src/lustre/element/mathml.gleam", 227).
?DOC("\n").
-spec mtr(
    list(lustre@vdom@vattr:attribute(WTY)),
    list(lustre@vdom@vnode:element(WTY))
) -> lustre@vdom@vnode:element(WTY).
mtr(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"mtr"/utf8>>,
        Attrs,
        Children
    ).
