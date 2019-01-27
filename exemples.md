# Exemples


<div class="viz-float-right"><div class="vizgraph">
digraph {


"pod A" [shape=circle]
"Git volume" [shape=cylinder]
"container1" [shape=cds]
"secret password" [shape=note]
"configmap host1" [shape=note]




"pod A" -> "Git volume"
"pod A" -> "container1"
"pod A" -> "secret password"
"pod A" -> "configmap host1"


"svc nodeport" [shape=hexagon]
"svc nodeport" -> "pod A" [ label=" label:app=true" ]

"deploy d" [shape=trapezium]
"replicaset d-a" [shape=house]
"deploy d" -> "replicaset d-a"
"replicaset d-a" -> "pod A" [ label=" label:app=true" ]


}
</div></div>

Quelques exemples d'utilisations des slides.

To live edit them: http://viz-js.com/


---

## Ex 2


<div class="viz-center"><div class="vizgraph">
digraph {

"pod A" [shape=circle]
"PVC" [shape=Msquare]
"PV" [shape=cylinder]
"pod A" -> "PVC"
"PVC" -> "PV"



subgraph cluster2 {
	style=filled;
    label = "node1";
    labelloc= "b";
    "pod B" [shape=circle];
}
subgraph cluster3 {
	style=filled;
    label = "node2";
    labelloc= "b";
    "pod C" [shape=circle];
}


"statefulset d-a" [shape=invhouse]
"statefulset d-a" -> "pod A" [ label=" label:app=true" ]


"daemonset d-a" [shape=parallelogram]
"daemonset d-a" -> "pod B" [ label=" label:app=true" ]
"daemonset d-a" -> "pod C" [ label=" label:app=true" ]


}

</div></div>





---

## Ex 3 placement

<div class="viz-float-right"><div class="vizgraph">
digraph { q -> u; }
</div></div>

<div class="viz-float-left"><div class="vizgraph">
digraph { q -> u; }
</div></div>


Donec et mollis ligula. Cras commodo maximus nisi a fringilla. Aenean dignissim enim velit, sit amet maximus nulla feugiat sed. Duis id auctor nisi. Interdum et malesuada fames ac ante ipsum primis in faucibus. Aliquam aliquam laoreet viverra. Fusce ipsum dolor, venenatis at odio sit amet, lobortis vehicula neque. Etiam nibh ligula, placerat eget sodales ut, luctus ut dolor. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Nam quis arcu bibendum, dapibus eros in, finibus nunc. 


<div class="viz-center"><div class="vizgraph">
digraph { q -> u; }
</div></div>







