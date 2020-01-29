#!/usr/bin/env zsh
FILE=$1
echo '<html>'
echo '<head>'
echo '<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>'
echo '<link rel="stylesheet" type="text/css" href="css/scenario.css">'
echo '</head>'
echo '<body>'
echo '<div class="wrapper">'
echo "<h1 class=\"title\">${FILE}</h1>"

sed -E 's;([^ ]+): ?(.+);<div class="line-\1 line"><div class="character-\1 character">\1</div><div class="speech-\1 speech">\2</div></div>;' $FILE |\
sed -E 's;([^ ]+)「(.+)」;<div class="line-\1 line"><div class="character-\1 character">\1</div><div class="speech-\1 speech">\2</div></div>;' |\
sed -E 's;^    (.+);<div class="direction">\1</div>;' |\
sed -E 's;^□(.+);</section> \
<h2 class="scene">\1</h2> \
<section>;' |\
sed -E '1s;</section>;<br>;' |\
sed -E '/^ *$/d'
echo '</div>'
echo '<script>$(".character").on("click", function (e) {var name = this.innerText;var speech = $(this).next("div")[0];var targets = $(".speech-" + name);if (speech.style.visibility == "visible" || speech.style.visibility == "") {$.each(targets, function () {this.style.visibility = "hidden";})} else {$.each(targets, function () {this.style.visibility = "visible";})}});</script>'
echo '</body>'
echo '</html>'
