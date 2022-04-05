# Analysis of Competing Hypotheses

The idea here is to apply the [ACH method](https://en.wikipedia.org/wiki/Analysis_of_competing_hypotheses) <sup>[1]</sup> in a way that is amenable to both humans and machines: making an analysis readable to both with [semantic markup of HTML](https://en.wikipedia.org/wiki/Semantic_HTML); and using [argumentation](https://en.wikipedia.org/wiki/Argumentation_theory) so that both can engage in the process. 

1.  Heuer, Richards J., Jr, "Chapter 8: Analysis of Competing Hypotheses", [_Psychology of Intelligence Analysis_](https://www.hsdl.org/?abstract&did=2899), Homeland Security Digital Library.

Consider Heur's **[worked example](https://dstl.github.io/eleatics/argumentation/examples/ach/heur.xhtml)**...

## Semantic markup ##

The example is [XHTML+RDFa](https://en.wikipedia.org/wiki/XHTML%2BRDFa), where [RDFa](http://rdfa.info/) provides the semantic markup that gives back linked data, and using [XHTML](en.wikipedia.org/wiki/XHTML) (rather than just HTML) brings XML manipulation utilities such as [XSLT](https://en.wikipedia.org/wiki/XSLT) into play. Tools like [RDFa Play](http://rdfa.info/play/) and [RDF Translator](http://rdf-translator.appspot.com/) will extract the RDF from the web page. For example, **RDF Translator** operates on [Heur's Iraq WMD example](https://dstl.github.io/eleatics/argumentation/examples/ach/heur.xhtml) to give this [RDF/XML](https://rdf-translator.appspot.com/convert/rdfa/xml/html/https%3A%2F%2Fdstl.github.io%2Feleatics%2Fargumentation%2Fexamples%2Fach%2Fheur.xhtml).

There is a choice to be made about which RDF vocabularies to use in the RDFa markup. Ultimately, we're aiming at generating [Argument Interchange Format (AIF)](http://www.argumentinterchange.org/) and applying [argumentation](https://en.wikipedia.org/wiki/Argumentation_theory) - but we don't have to get there in one go. Instead, we might want to consider:

1. Argumentation isn't the only game in town. Let's not shut the door on other engines for ACH by making this too argumentation specific.

2. The ACH method encourages group discussion, and it encourages discussion of evidence and hypotheses when assigning them to the matrix, and it says all evidence and assumptions should be recorded. This suggests an "information list" is the central data structure around which the method revolves.

3. The semantic markup should be kept simple enough that the web page can be fairly easily hand-edited by someone who is not an expert in RDFa.

We could annotate hypothesis and evidence as AIF I-nodes, but with points 1 and 2 in mind, we've gone for [SKOS](https://www.w3.org/TR/skos-primer/) as the RDF vocabulary. It would be possible (but by no means straightforward) to annotate each cell in the matrix table as an AIF S-node, but this makes the web page source a bit too complicated (point 3). Instead, consistency or inconsistency between evidence and hypothesis is implicit in the structure of the HTML table, and can be made explicit (as AIF S-nodes) by an XSL transform of the XHTML.

## Making an argument map ##

The XSL stylesheet that does this is **[ach-to-aif.xsl](https://github.com/dstl/eleatics/blob/master/argumentation/xsl/ach-to-aif.xsl)**. It does the following:

1. Make an **I-node** for each SKOS **Concept** in the web page. The _definition_ of the Concept becomes the _claimText_ of the I-node.

1. Make an **S-node** for each cell in the ACH matrix. The _premise_ is the evidence marked up in the **th** element for the **tr** element containing the **td** element (matrix cell), and the _conclusion_ is the hypothesis marked up in **th** element for the relevant column. The HTML _@scope="col"_ attribute is used to label the **th** elements that are the hypotheses, and the offset of the matrix cell **td** element within a row is used to index the relevant hypothesis from a list of these column headers. The S-node created will be an **RA-node** if the evidence is consistent with the hypothesis, and a **CA-node** if it is inconsistent. Consistency or inconsistency is indicated by the class attribute on the **td** element that is the matrix cell (_@class="plus"_ and _@class="minus"_ respectively).
 
## The ACH method ##

Manipulating the matrix is just steps 3 and 4 of an 8 step process - and an iterative process at that. Argumentation can be used in selecting the evidence and hypotheses that form the matrix, with a larger argument map recording the information that didn't make the cut. It can also help in refining the matrix. For example, it's clear that **E1** is not diagnostic because it doesn't attack any hypothesis. An argument stating this can be added to the argument map so that **E1** becomes inadmissible. Logically, this has the same effect as simply deleting it, but doing it this way means that there is a record of **E1** being considered and rejected.

Evaluating the argument map for Heur's example gives four extensions: with one, both or neither of **H1** and **H3** being acceptable, and **H2** always acceptable. There's a point to consider about whether "competing" means the hypotheses should contradict each other, so that only one is acceptable in any given extension. This might be something you want to do if a machine agent is using ACH to make a decision. However, for the human analyst, Heur says "the matrix should not dictate the conclusion to you". The ACH method seems to be about using evidence to  assess the "competing" hypotheses in parallel, but essentially independently. It's an open question as to whether explicit competition between hypotheses, coded as logical arguments, adds any value.

A preferred extension in which a hypothesis is acceptable will also contain the evidence that supports that hypothesis. This is useful for sensitivity analysis. Arguments can be added that challenge key items of evidence and the argument map re-evaluated. How conclusions stand up to this sort of criticism will say something about how certain those conclusions are. Such critical questions are also a way of considering the possibility for deception, and identifying milestones for future observations.  

## Notes ##

1. A plus or minus in a matrix cell translates simply to defeasible support or contradiction (and the double minus is just treated as a minus). Is this good enough? Heur offers a few alternatives for how the relationship between evidence and hypothesis might be recorded in the matrix. The suggestion here is that a simple translation to arguments is sufficient to generate the argument map, and that any extra information recorded in the ACH matrix cell can be used in sensitivity analysis and in drawing conclusions.

1. Sensitivity analysis suggests that the linkage between the generated argumentation system and a knowledge base needs some thought. This linkage would be done by some notional analysis tool, but the point here is that generating axioms and ordinary premises needs to be separate for generating the argument map so that the former can be manipulated independently of the latter.

1. Extension semantics can be exploited when expressing the certainty of conclusions, as can meta arguments about evidence and hypotheses. Machine agents that take different stances ("dove", "hawk", "devil's advocate", ...) might take a role in establishing conclusions. There is a lot to think about here.
