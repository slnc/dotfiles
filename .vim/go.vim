<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

  <title>misc/vim/indent/go.vim - The Go Programming Language</title>

<link type="text/css" rel="stylesheet" href="/doc/style.css">
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js"></script>
<script type="text/javascript">window.jQuery || document.write(unescape("%3Cscript src='/doc/jquery.js' type='text/javascript'%3E%3C/script%3E"));</script>

<script type="text/javascript" src="/doc/play/playground.js"></script>

<script type="text/javascript" src="/doc/godocs.js"></script>

<link rel="search" type="application/opensearchdescription+xml" title="godoc" href="/opensearch.xml" />

<script type="text/javascript">
var _gaq = _gaq || [];
_gaq.push(["_setAccount", "UA-11222381-2"]);
_gaq.push(["_trackPageview"]);
</script>
</head>
<body>

<div id="topbar" class="wide"><div class="container">

<form method="GET" action="/search">
<div id="menu">
<a href="/doc/">Documents</a>
<a href="/ref/">References</a>
<a href="/pkg/">Packages</a>
<a href="/project/">The Project</a>
<a href="/help/">Help</a>

<a id="playgroundButton" href="http://play.golang.org/" title="Show Go Playground">Play</a>

<input type="text" id="search" name="q" class="inactive" value="Search" placeholder="Search">
</div>
<div id="heading"><a href="/">The Go Programming Language</a></div>
</form>

</div></div>


<div id="playground" class="play">
	<div class="input"><textarea class="code">package main

import "fmt"

func main() {
	fmt.Println("Hello, 世界")
}</textarea></div>
	<div class="output"></div>
	<div class="buttons">
		<a class="run" title="Run this code [shift-enter]">Run</a>
		<a class="fmt" title="Format this code">Format</a>
		<a class="share" title="Share this code">Share</a>
	</div>
</div>


<div id="page" class="wide">
<div class="container">


  <div id="plusone"><g:plusone size="small" annotation="none"></g:plusone></div>
  <h1>Text file misc/vim/indent/go.vim</h1>




<div id="nav"></div>


<pre><a id="L1"></a><span class="ln">     1</span>	&#34; Copyright 2011 The Go Authors. All rights reserved.
<a id="L2"></a><span class="ln">     2</span>	&#34; Use of this source code is governed by a BSD-style
<a id="L3"></a><span class="ln">     3</span>	&#34; license that can be found in the LICENSE file.
<a id="L4"></a><span class="ln">     4</span>	&#34;
<a id="L5"></a><span class="ln">     5</span>	&#34; indent/go.vim: Vim indent file for Go.
<a id="L6"></a><span class="ln">     6</span>	&#34;
<a id="L7"></a><span class="ln">     7</span>	&#34; TODO:
<a id="L8"></a><span class="ln">     8</span>	&#34; - function invocations split across lines
<a id="L9"></a><span class="ln">     9</span>	&#34; - general line splits (line ends in an operator)
<a id="L10"></a><span class="ln">    10</span>	
<a id="L11"></a><span class="ln">    11</span>	if exists(&#34;b:did_indent&#34;)
<a id="L12"></a><span class="ln">    12</span>	    finish
<a id="L13"></a><span class="ln">    13</span>	endif
<a id="L14"></a><span class="ln">    14</span>	let b:did_indent = 1
<a id="L15"></a><span class="ln">    15</span>	
<a id="L16"></a><span class="ln">    16</span>	&#34; C indentation is too far off useful, mainly due to Go&#39;s := operator.
<a id="L17"></a><span class="ln">    17</span>	&#34; Let&#39;s just define our own.
<a id="L18"></a><span class="ln">    18</span>	setlocal nolisp
<a id="L19"></a><span class="ln">    19</span>	setlocal autoindent
<a id="L20"></a><span class="ln">    20</span>	setlocal indentexpr=GoIndent(v:lnum)
<a id="L21"></a><span class="ln">    21</span>	setlocal indentkeys+=&lt;:&gt;,0=},0=)
<a id="L22"></a><span class="ln">    22</span>	
<a id="L23"></a><span class="ln">    23</span>	if exists(&#34;*GoIndent&#34;)
<a id="L24"></a><span class="ln">    24</span>	  finish
<a id="L25"></a><span class="ln">    25</span>	endif
<a id="L26"></a><span class="ln">    26</span>	
<a id="L27"></a><span class="ln">    27</span>	function! GoIndent(lnum)
<a id="L28"></a><span class="ln">    28</span>	  let prevlnum = prevnonblank(a:lnum-1)
<a id="L29"></a><span class="ln">    29</span>	  if prevlnum == 0
<a id="L30"></a><span class="ln">    30</span>	    &#34; top of file
<a id="L31"></a><span class="ln">    31</span>	    return 0
<a id="L32"></a><span class="ln">    32</span>	  endif
<a id="L33"></a><span class="ln">    33</span>	
<a id="L34"></a><span class="ln">    34</span>	  &#34; grab the previous and current line, stripping comments.
<a id="L35"></a><span class="ln">    35</span>	  let prevl = substitute(getline(prevlnum), &#39;//.*$&#39;, &#39;&#39;, &#39;&#39;)
<a id="L36"></a><span class="ln">    36</span>	  let thisl = substitute(getline(a:lnum), &#39;//.*$&#39;, &#39;&#39;, &#39;&#39;)
<a id="L37"></a><span class="ln">    37</span>	  let previ = indent(prevlnum)
<a id="L38"></a><span class="ln">    38</span>	
<a id="L39"></a><span class="ln">    39</span>	  let ind = previ
<a id="L40"></a><span class="ln">    40</span>	
<a id="L41"></a><span class="ln">    41</span>	  if prevl =~ &#39;[({]\s*$&#39;
<a id="L42"></a><span class="ln">    42</span>	    &#34; previous line opened a block
<a id="L43"></a><span class="ln">    43</span>	    let ind += &amp;sw
<a id="L44"></a><span class="ln">    44</span>	  endif
<a id="L45"></a><span class="ln">    45</span>	  if prevl =~# &#39;^\s*\(case .*\|default\):$&#39;
<a id="L46"></a><span class="ln">    46</span>	    &#34; previous line is part of a switch statement
<a id="L47"></a><span class="ln">    47</span>	    let ind += &amp;sw
<a id="L48"></a><span class="ln">    48</span>	  endif
<a id="L49"></a><span class="ln">    49</span>	  &#34; TODO: handle if the previous line is a label.
<a id="L50"></a><span class="ln">    50</span>	
<a id="L51"></a><span class="ln">    51</span>	  if thisl =~ &#39;^\s*[)}]&#39;
<a id="L52"></a><span class="ln">    52</span>	    &#34; this line closed a block
<a id="L53"></a><span class="ln">    53</span>	    let ind -= &amp;sw
<a id="L54"></a><span class="ln">    54</span>	  endif
<a id="L55"></a><span class="ln">    55</span>	
<a id="L56"></a><span class="ln">    56</span>	  &#34; Colons are tricky.
<a id="L57"></a><span class="ln">    57</span>	  &#34; We want to outdent if it&#39;s part of a switch (&#34;case foo:&#34; or &#34;default:&#34;).
<a id="L58"></a><span class="ln">    58</span>	  &#34; We ignore trying to deal with jump labels because (a) they&#39;re rare, and
<a id="L59"></a><span class="ln">    59</span>	  &#34; (b) they&#39;re hard to disambiguate from a composite literal key.
<a id="L60"></a><span class="ln">    60</span>	  if thisl =~# &#39;^\s*\(case .*\|default\):$&#39;
<a id="L61"></a><span class="ln">    61</span>	    let ind -= &amp;sw
<a id="L62"></a><span class="ln">    62</span>	  endif
<a id="L63"></a><span class="ln">    63</span>	
<a id="L64"></a><span class="ln">    64</span>	  return ind
<a id="L65"></a><span class="ln">    65</span>	endfunction
</pre><p><a href="/misc/vim/indent/go.vim?m=text">View as plain text</a></p>

<div id="footer">
Build version go1.0.3.<br>
Except as <a href="http://code.google.com/policies.html#restrictions">noted</a>,
the content of this page is licensed under the
Creative Commons Attribution 3.0 License,
and code is licensed under a <a href="/LICENSE">BSD license</a>.<br>
<a href="/doc/tos.html">Terms of Service</a> | 
<a href="http://www.google.com/intl/en/policies/privacy/">Privacy Policy</a>
</div>

</div><!-- .container -->
</div><!-- #page -->

<script type="text/javascript">
(function() {
  var ga = document.createElement("script"); ga.type = "text/javascript"; ga.async = true;
  ga.src = ("https:" == document.location.protocol ? "https://ssl" : "http://www") + ".google-analytics.com/ga.js";
  var s = document.getElementsByTagName("script")[0]; s.parentNode.insertBefore(ga, s);
})();
</script>
</body>
<script type="text/javascript">
  (function() {
    var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
    po.src = 'https://apis.google.com/js/plusone.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
  })();
</script>
</html>

