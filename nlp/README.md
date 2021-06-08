# Baleen XML

This is an XML format for capturing the results of natural language processing. It is fully described in the [Baleen XML Schema definition](baleen.xsd).

The schema is designed so that the most elements are optional, and the format can describe the results at any stage of a text processing pipeline. 
For instance, a document is valid with just a *text* element (plain text extraction); with just text and empty *sentence* elements (sentence segmentation); 
with text, sentences and empty *token* elements (tokenization); and with text, sentences and populated tokens (part-of-speech tagging). 
NLP processes that label spans of text (such as dictionary matching) are supported by the *annotation* element. An example file in this format is [here](examples/simple.xml).

Parse tree structures are supported by allowing tokens to nest within tokens, so a noun phrase for example can be represented as a single token at the top-level 
within a sentence, as shown [here](examples/nested.xml), where noun and verb phrases are expressed as nested tokens rather than annotations. A factor of the design 
is that the simple tokens are preserved, so any processes of this type are reversible (or otherwise modifiable).

Dependency grammar parsers are supported by the *dependent* element.

The *annotation* elements allow for arbitrary labels to be applied to spans of text that do not necessarily respect the token boundaries. 
For processes like phrase-chunking, which operate on existing tokenization, it is a matter of choice to record the results as nested tokens or annotations.

The particular examples show here were generated using [Baleen](https://github.com/dstl/baleen), with OpenNLP language parser, WordNet lemmatizer and some gazetteers for 
named entity recognition. The CAS for each processed document was serialized to XMI, and the serialized CAS XSL transformed to Baleen XML format. Note however, 
that the XML format itself is independent of the Baleen/Annot8 framework, or any other NLP framework.
