# Argumentation

*Supporting the interchange of [argument](https://en.wikipedia.org/wiki/Argumentation_theory) as Argument Interchange Format ([AIF](http://www.argumentinterchange.org/)).*

## Representation

### Argument Maps
[OVA+](https://arg-tech.org/index.php/projects/ova-2/) is an online tool that lets you create and save an [argument map](https://en.wikipedia.org/wiki/Argument_map) as AIF. It's possible to draw the same sort of arguments map using something like the 
[yEd Graph Editor](https://www.yworks.com/products/yed), and then transform the resulting diagram to AIF.

* [Converting GraphML to AIF](graphml)

### HTML
We want arguments that make sense to both humans and machines. An argument can be laid out text as on a web page for the human reader that is made accessible to a machine reasoning agent through [semantic mark-up](https://en.wikipedia.org/wiki/Semantic_HTML). In particular, [RDFa](https://en.wikipedia.org/wiki/RDFa) allows [linked data](https://en. wikipedia.org/wiki/Linked_data) to be embedded in HTML.

* [A general purpose RDFa extractor](https://github.com/dstl/eleatics/wiki/RDFa)

## Evaluation

### Argumentation Schemes

[Argumentation schemes](https://en.wikipedia.org/wiki/Argumentation_scheme) are patterns describing particular classes or types of argument. They are useful in evaluating arguments, explaining the conclusions reached by an argument, and arguing about arguments.

We maintain a working document describing the schemes used within **eleatics**, which is both human and machine readable (along the lines discussed in the [Knowledge Representation](/eleatics/KR) section).

* [Argumentation Schemes - working document](https://dstl.github.io/eleatics/argumentation/schemes.xhtml)
* Wiki: [Argumentation Schemes](https://github.com/dstl/eleatics/wiki/Argumentation-Schemes)
