# Arguments as Text

## XHTML+RDFa

We consider an *argument* as an AIF S-node, together with its premises and conclusions. An HTML <p> element acts as the container for the argument and 
takes the role of S-node. HTML <span> elements within the paragraph are marked up as premise and conclusion properties.


```
about="{undercut-uri}" typeof="aif:CA-node" property="aif:Conclusion" resource="{s-node}"
```

then any premises from the undercutting argument can be explicitly labelled as properties of *undercut-url*:

```
about="{undercut-uri}" resource="{premise-uri}" property="aif:Premise"
```

For convergent arguments, we have more than one S-node leading to the the same conclusion. In this case, it is the conclusion that acts as the 
container for the argument with `rev="aif:Conclusion"`. A contained `<span>` element defines each S-node, and specifies the appropriate
premise as a resource.

Arguments for and against some proposition may be expressed as lists of pros ans cons.


N.B. The mark-up does not define I-node types or the claimText property of the I-nodes.
