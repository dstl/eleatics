[Argumentation Schemes](https://en.wikipedia.org/wiki/Argumentation_scheme) represent stereotypical patterns of reasoning. Of particular interest are
those described in [Douglas Walton's](https://en.wikipedia.org/wiki/Douglas_N._Walton) book: [*Argumentation Schemes for Presumptive Reasoning*](https://books.google.co.uk/books?id=5c_5AQAAQBAJ&dq=Argumentation+Schemes+for+Presumptive+Reasoning,+Mahwah,+N.J.,+Lawrence+Erlbaum+Associates,+1996.&lr=). Walton's schemes are modelled in the AIF vocabulary, and descriptions for a selection of them have been published by [ReasoningLab](https://www.reasoninglab.com/patterns-of-argument/argumentation-schemes/waltons-argumentation-schemes/).

A wider interpretation of "stereotypical patterns" might also include characteristic sub-graphs of an argument map that could be used to condense or summarize it. We'll set these *pattern* schemes aside for the moment and deal here with *presumptive* schemes.

## Schemes for presumptive inference

**[schemes.xhtml](https://dstl.github.io/eleatics/argumentation/schemes.xhtml)** is a working document describing the presumptive schemes that we'll use within **eleatics**. It is marked up with [RDFa](RDFa) that will generate the corresponding AIF.

### Assigning presumptive schemes

In an AIF argument map, we may label any *S-node* as an example of a presumptive scheme by also typing it as some subclass of *aif:Presumptive_Inference*. We may label some, all or none of the inferences in this way.

For the purpose of critical analysis, we may consider any claim in an argument map as the conclusion of some presumptive scheme, thereby bringing into play any critical questions associated with that scheme.
This makes particular sense when critiquing the claims in an argument map that are premises only, and therefore not justified as the conclusions of some inference step in the argument map. We'll call such premises *evidence*.

The evidence in an argument can be characterized by argumentation scheme. For example, one claim might be an *Expert Opinion*, and another an *Established Rule*. As the evidential claim is not a conclusion, there is no S-node on which to hang the argumentation scheme type as a label. We can get round this by considering the argumentation scheme URI as an RDF container, and then associating an evidential claim with a scheme by making its *I-node* a member of the relevant container. The [Fortitude South](https://dstl.github.io/eleatics/argumentation/fortitude/) example demonstrates this [assignment of evidence to schemes](https://dstl.github.io/eleatics/argumentation/fortitude/schemes.xhtml) with a human-readable HTML page marked up with machine-readable [RDFa](../RDFa).

### Applying presumptive schemes

There is value to be had in just considering the labelling of an argument map by presumptive scheme. For the purposes of critical analysis we need to go further and construct a *meta-argument* around each instance of a presumptive scheme. The points to consider are:

* The meta-argument is a critique. It might be for the purposes of eliciting information, or it might represent some quality or regulatory barrier that an argument is expected to clear.
* Criticism of an argument implies at least two agents. Eliciting information implies a dialogue. The agents may be human or machine.
* Any critique of an argument must add rather than subtract value. Its benefits must outweigh its costs, and its costs are measured in how difficult and time consuming it is for all concerned to engage in the process.

We base meta-arguments on the [Toulmin argument layout](https://dstl.github.io/eleatics/argumentation/toulmin/). This provides a generic and easily understood description of a presumptive argument. We make an [XHTML+RDFa template](https://dstl.github.io/eleatics/argumentation/toulmin/toulmin.xhtml) from the Toulmin pattern. From this we can generate a more specialized template for each presumptive scheme. See example templates for [*Argument from Evidence to Hypothesis*](https://dstl.github.io/eleatics/argumentation/schemes/E2H.xhtml) and [*Argument from Established Rule*](https://dstl.github.io/eleatics/argumentation/schemes/RULE.xhtml). Given the scheme templates, we can create individual meta-arguments as desired.

### Context

We assume that a meta-argument is evaluated in the context of an explicit *S-node*, or in the context of an evidence *I-node*. The corresponding AIF nodes in the Toulmin pattern have the URI's **toulmin:infers** for the S-node and **toulmin:claim** for the *I-node*. In the *S-node* case, an AIF *S-node* can only have one conclusion, so matching **toulmin:infers** to the *S-node* automatically matches **toulmin:claim** to that conclusion. In the evidence *I-node* case, **toulmin:claim** is matched to the *I-node* and is the only linkage needed.

We must also consider the context in evaluating a meta-argument: how multiple meta-arguments about the same inference or claim might be evaluated together or separately, and whether the purpose of the meta-argument is to affect the construction of an argument theory or to interpret its results.
