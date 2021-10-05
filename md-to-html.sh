#!/usr/bin/env zsh
FILE=$1
echo '<html>'
echo '<head>'
echo '<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>'
cat << CSS
<style type="text/css">
    @page {
        /*size: A4 landscape;*/
        size: landscape;
        margin: 0;
        /*height: 210mm;
        width: 297mm;*/
    }
    html {
        font-size: 16px;
    }
    body {
        /* 縦書き */
        -webkit-writing-mode: vertical-rl;
        -ms-writing-mode: tb-rl;
        writing-mode: vertical-rl;
        /*height: 49rem;*/
        height: 210mm;
        padding: 2rem;
    }
    .wrapper {
        margin: auto 0 auto 0;
    }
    h1 {
        margin: 3rem 1rem 0 0;
    }
    h2 {
        margin-top: 2rem;
    }
    h2:before {
        content: '○';
    }
    section {
        height: 190mm;
        /* 基本余白 */
        /*padding: 0.5rem;*/
        padding: 10mm;
    }
    .direction {
        /* 行あたり文字数指定 */
        height: 25rem;
        /* ト書き字下げ 改行対応のためtext-indentを使わない */
        margin-top: 9rem;
    }

    .line + .direction,
    .direction + .line {
        /* ト書き前後行空け */
        padding-right: 1rem;
    }
    .line {
        /* 基本行間 */
        line-height: 1.8rem;
        /* 役名と台詞の整列 */
        display: flex;
    }
    .character {
        height: 5rem;
    }
    .speech {
        /* 行あたり文字数指定 */
        height: 42rem;
        margin-top: 2rem;
    }
</style>
CSS
echo '</head>'
echo '<body>'
echo '<div class="wrapper">'
echo "<h1 class=\"title\">${FILE}</h1>"

# 役名: 形式の処理
sed -E 's;([^ ]+): ?(.+);<div class="line-\1 line"><div class="character-\1 character">\1</div><div class="speech-\1 speech">\2</div></div>;' $FILE |\
# 役名「セリフ」形式の処理
sed -E 's;^([^ ]+)「(.+)」;<div class="line-\1 line"><div class="character-\1 character">\1</div><div class="speech-\1 speech">\2</div></div>;' |\
# 役名    （空白３つ）形式の処理
sed -E 's;([^ ]+)    (.+);<div class="line-\1 line"><div class="character-\1 character">\1</div><div class="speech-\1 speech">\2</div></div>;' |\
# 4文字下げしてたらト書き
sed -E 's;^    (.+);<div class="direction">\1</div>;' |\
# 頭に□◯があれば場のあたま
sed -E 's;^[□◯](.+);</section> \
<h2 class="scene">\1</h2> \
<section>;' |\
# 冒頭の閉じタグは除去
sed -E '1s;</section>;<br>;' |\
sed -E '/^ *$/d'
# 終了処理
echo '</div>'
echo '<script>$(".character").on("click", function (e) {var name = this.innerText;var speech = $(this).next("div")[0];var targets = $(".speech-" + name);if (speech.style.visibility == "visible" || speech.style.visibility == "") {$.each(targets, function () {this.style.visibility = "hidden";})} else {$.each(targets, function () {this.style.visibility = "visible";})}});</script>'
echo '</body>'
echo '</html>'
