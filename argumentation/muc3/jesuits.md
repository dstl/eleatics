# The Jesuits Massacre

See the [1989 murders of Jesuits in El Salvador](https://en.wikipedia.org/wiki/1989_murders_of_Jesuits_in_El_Salvador) Wikipedia page for a description of this atrocity committed during the Salvadoran Civil War. Nobody claimed responsibility for the attack - and initial reports contained claim and counter-claim about who was responsible for the murders. The truth emerged over time, ultimately leading to a comprehensive description of events in a [UN Truth Commission report](http://www.derechos.org/nizkor/salvador/informes/truth.html).

Contemperaneous reports relating to the massacre can be found in the [MUC-3 corpus](https://github.com/dstl/muc3). These can be used to demonstrate developing hypotheses based on testimonial evidence, and in updating hypotheses over time in the light of new evidence.

## The Analyst Perspective

1. Firstly, collecting evidence, listing [excerpts](https://dstl.github.io/eleatics/argumentation/muc3/jesuits-excerpts.xhtml) from reports that make claims and allegations.

2. Next, [rephrasing](https://dstl.github.io/eleatics/argumentation/muc3/jesuits-rephrase.xhtml) these excerpts to to distil out the claims made. Analyst judgements can be added at the stage.

3. Creating an [information list](https://dstl.github.io/eleatics/argumentation/muc3/jesuits-information.xhtml) of evidence for use in [analysis](/eleatics/SAT).

4. Applying a structured analytic technique, such as [ACH](https://dstl.github.io/eleatics/argumentation/muc3/jesuits-ach.xhtml).

## The Technical Perspective

The example web pages are marked up according to the [AIF dialogical model](https://www.arg-tech.org/people/chris/publications/2010/comma2010-reed.pdf). AIF models the concepts of *locution*, *rephrasing* and *illocutionary force* that link the excerpts, their rephrasing, and the evidence they claim. This means that any conclusions reached by arguments from testimony can be traced back to source - and issues of trust and credibility can be considered in deciding whether to accept those conclusions.

There are number of manual tasks here that gloss over active research topics in natural language processing: *Event Extraction* to identify the event of interest and the documents that report it; *Argument Mining* to identify premises and conclusions expressed in those documents; and *Intertextual Correspondence* to piece together arguments extracted from various reports to create a cohesive argument map. The idea is that any future machine process conducting these tasks would interact with the linked data model in the same way.


