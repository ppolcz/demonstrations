#!/usr/bin/python
# -*- coding: utf-8 -*-
import sys, re, os, shutil

from bs4 import Tag, Comment, NavigableString, BeautifulSoup

"""
<class 'bs4.element.Tag'>
['HTML_FORMATTERS', 'XML_FORMATTERS', '__call__', '__class__', '__contains__', '__copy__', '__delattr__', '__delitem__', '__dict__', '__doc__',
'__eq__', '__format__', '__getattr__', '__getattribute__', '__getitem__', '__hash__', '__init__', '__iter__', '__len__', '__module__', '__ne__',
'__new__', '__nonzero__', '__reduce__', '__reduce_ex__', '__repr__', '__setattr__', '__setitem__', '__sizeof__', '__str__', '__subclasshook__',
'__unicode__', '__weakref__', '_all_strings', '_attr_value_as_string', '_attribute_checker', '_find_all', '_find_one', '_formatter_for_name',
'_is_xml', '_lastRecursiveChild', '_last_descendant', '_select_debug', '_selector_combinators', '_should_pretty_print', '_tag_name_matches_and',
'append', 'attribselect_re', 'attrs', 'can_be_empty_element', 'childGenerator', 'children', 'clear', 'contents', 'decode', 'decode_contents',
'decompose', 'descendants', 'encode', 'encode_contents', 'extract', 'fetchNextSiblings', 'fetchParents', 'fetchPrevious', 'fetchPreviousSiblings',
'find', 'findAll', 'findAllNext', 'findAllPrevious', 'findChild', 'findChildren', 'findNext', 'findNextSibling', 'findNextSiblings', 'findParent',
'findParents', 'findPrevious', 'findPreviousSibling', 'findPreviousSiblings', 'find_all', 'find_all_next', 'find_all_previous', 'find_next',
'find_next_sibling', 'find_next_siblings', 'find_parent', 'find_parents', 'find_previous', 'find_previous_sibling', 'find_previous_siblings',
'format_string', 'get', 'getText', 'get_attribute_list', 'get_text', 'has_attr', 'has_key', 'hidden', 'index', 'insert', 'insert_after',
'insert_before', 'isSelfClosing', 'is_empty_element', 'known_xml', 'name', 'namespace', 'next', 'nextGenerator', 'nextSibling', 'nextSiblingGenerator',
'next_element', 'next_elements', 'next_sibling', 'next_siblings', 'parent', 'parentGenerator', 'parents', 'parserClass', 'parser_class', 'prefix',
'preserve_whitespace_tags', 'prettify', 'previous', 'previousGenerator', 'previousSibling', 'previousSiblingGenerator', 'previous_element',
'previous_elements', 'previous_sibling', 'previous_siblings', 'quoted_colon', 'recursiveChildGenerator', 'renderContents', 'replaceWith',
'replaceWithChildren', 'replace_with', 'replace_with_children', 'select', 'select_one', 'setup', 'string', 'strings', 'stripped_strings',
'tag_name_re', 'text', 'unwrap', 'wrap']
[Finished in 0.1s]
"""

def demo():
    soup = BeautifulSoup("<div class='content'><b>Kutyagumi</b> not bolt <b>bold again</b><div>alma</div></div><a>asd</a>", "html.parser")
    sys.stdout.write("\nBEFORE:\n" + str(soup) + "\n\n")

    print(soup.div)

    new_tag = soup.new_tag("span")
    new_tag.string = "example.net"
    new_tag["class"] = "bold"

    x = soup.div.b

    x.replace_with(new_tag)

    sys.stdout.write("\nAFTER:\n" + str(soup) + "\n\n")

    print(' ')
    print('FOR LOOP')
    for x in soup.div:
        sys.stdout.write(str(type(x)) + ":" + str(x) + "\n")

    sys.stdout.write('\n\nFind div with class content:\n')

    print(dir(soup.div))

    x = soup.find_all("div", class_="content")
    print(x)
    x = soup.find_all("div", "content")
    print(x)
    x = soup.find_all("div", attrs={"class": "content"})
    print(x)
    x = soup.find_all("div.content") # this is not good
    print(x)

def criteria_imglatex(tag):
    return tag.name == "img" and tag.has_attr('alt') and "$" in tag["alt"]

def criteria_simplepre(tag):
    return tag.name == "pre" and not tag.has_attr('class')

def a_href_slx(href):
    return href and re.compile(".*\.slx").search(href)

def a_href_img(href):
    return href and re.compile(".*\.(png|jpg)").search(href)

def a_href_br(href):
    return href and re.compile("br").search(href)

def main(ipath = "/home/ppolcz/Repositories/Bitbucket/control-systems/demonstrations/oktatas/anal3/html/anal3_vekanal_1.html",
         opath = "/home/ppolcz/Repositories/Bitbucket/control-systems/html/publish_demo2_output.html",
         scriptpath = None,
         livepath = None,
         livepublished = None):
    contents = open(ipath, 'r').read()
    f = open(opath, 'w')

    soup = BeautifulSoup(contents, "html.parser")
    content = soup.find_all("div", class_="content", limit=1)[0]

    # print(type(content))
    # print(dir(content))

    sourcedir = None
    if livepath and os.path.isdir(livepath):
        sourcedir = livepath
        livepath = None

    targetdir = os.path.dirname(ipath)

    # print("sourcedir = " + sourcedir)
    # print("targetdir = " + targetdir)

    if scriptpath:
        p = soup.new_tag("p")
        p["class"] = "text-muted"
        p.append("\n    ")

        print("ipath = " + ipath)
        print("opath = " + opath)
        print("scriptpath = " + scriptpath)

        a = soup.new_tag("a")
        a["href"] = "<?php echo base_url(); ?>/" + scriptpath
        a.append("Teljes Matlab script")
        p.append(a)
        p.append("\n    ")

        if livepath:
            a = soup.new_tag("a")
            a["href"] = "<?php echo base_url(); ?>/" + livepath
            a.append("live script")
            p.append("(és ")
            p.append(a)
            p.append(")\n    ")

        github = soup.new_tag("a")
        github["href"] = "https://github.com/ppolcz/demonstrations"
        github.append("kiegészítő függvényekkel")
        p.append(github)
        p.append(".")

        if livepublished:
            br = soup.new_tag("br")
            p.append("\n")
            p.append(br)
            p.append("\n    ")

            a = soup.new_tag("a")
            a["href"] = "<?php echo base_url(); ?>/" + livepublished
            a["class"] = "text-danger bold big"
            a.append("\n        ")
            a.append("Tekintsd meg LiveEditor nézetben is!")
            a.append("\n    ")
            p.append(a)

        p.append("\n")

        content.insert(1,p)

    # Collect Simulink models
    for a in content.find_all(href=re.compile("sim|file"), string=re.compile(".*\.(slx|m|mat|nb|html|htm|pdf)")):
        print(a)
        slxname = a.string
        src = sourcedir + "/" + slxname

        if os.path.isfile(src) and os.path.isdir(targetdir):
            shutil.copy2(src, targetdir)

            scriptdir = os.path.basename(targetdir)
            # print("scriptdir = " + scriptdir)

            a["href"] = "<?php echo base_url(); ?>files/scripts/" + scriptdir + "/" + slxname

        # print(a)

    # for a in content.find_all(href=a_href_slx, string=re.compile("Simulink")):
    #     # print(a)
    #     slxname = a["href"]
    #     src = sourcedir + "/" + slxname

    #     if os.path.isfile(src) and os.path.isdir(targetdir):
    #         shutil.copy2(src, targetdir)

    #         scriptdir = os.path.basename(targetdir)
    #         # print("scriptdir = " + scriptdir)

    #         a["href"] = "<?php echo base_url(); ?>files/scripts/" + scriptdir + "/" + slxname
    #         a.string = "Download Simulink model (" + slxname + ")"

    #     # print(a)

    # Collect images
    for a in content.find_all(href="img", string=re.compile(".*\.(png|jpg)")):
        print(a)

        imgname = a.string
        src = sourcedir + "/" + imgname

        if os.path.isfile(src) and os.path.isdir(targetdir):
            targetpath = targetdir + "/" + os.path.dirname(imgname)
            print("src = " + src)
            print("targetpath = " + targetpath)

            if not os.path.exists(targetpath):
                os.makedirs(targetpath)

            shutil.copy2(src, targetpath)

            scriptdir = os.path.basename(targetdir)
            print("scriptdir = " + scriptdir)

            a.name = "img"
            a.attrs = { "src": imgname }
            a.string = ""

    # Lásd még sim|file --> ugyanazt csinalja (csak a ROOT mappabol indulva)
    # 2018.07.30. (július 30, hétfő), 10:54
    # Collect scripts
    # <script 2_demonstrations/lib/matlab/vekanal_subsmesh.m>
    for a in content.find_all(href="script", string=re.compile(".*\.m")):
        # print(a)

        scriptname = a.string
        src = "/home/ppolcz/Repositories/Bitbucket/control-systems/" + scriptname

        if os.path.isfile(src) and os.path.isdir(targetdir):
            targetpath = targetdir + "/" + os.path.dirname(scriptname)
            # print("src = " + src)
            # print("targetpath = " + targetpath)

            if not os.path.exists(targetpath):
                os.makedirs(targetpath)

            shutil.copy2(src, targetpath)

            scriptdir = os.path.basename(targetdir)
            # print("scriptdir = " + scriptdir)

            a.name = "a"
            a.attrs = { "href": "<?php echo \"$media\"; ?>/" + scriptname }
            a.string = os.path.basename(scriptname)

    # for a in content.find_all(href=a_href_img, string=re.compile("img")):
    #     # print(a)

    #     imgname = a["href"]
    #     src = sourcedir + "/" + imgname

    #     if os.path.isfile(src) and os.path.isdir(targetdir):
    #         targetpath = targetdir + "/" + os.path.dirname(imgname)
    #         # print("src = " + src)
    #         # print("targetpath = " + targetpath)

    #         if not os.path.exists(targetpath):
    #             os.makedirs(targetpath)

    #         shutil.copy2(src, targetpath)

    #         scriptdir = os.path.basename(targetdir)
    #         # print("scriptdir = " + scriptdir)

    #         a.name = "img"
    #         a.attrs = { "src": imgname }
    #         a.string = ""

    # Collect <a href="br">br</a> tags and rewrite to <br></br>
    # for a in content.find_all(href=a_href_br, string=re.compile("br")):
    for a in content.find_all(href="br", string="br"):
        a.replace_with(soup.new_tag("br"))

    # Remove all comments
    for element in content(text=lambda text: isinstance(text, Comment)):
        element.extract()

    # Replace prerendered latex images with their latex code
    imgs = content.find_all(criteria_imglatex)
    for img in imgs:
        img.replace_with(img["alt"])

    # Format Matlab code
    # <pre class="codeinput">
    # <pre class="language-matlab">
    pres = content.find_all("pre", class_=re.compile("(codeinput|language-matlab)"))
    for pre in pres:
        pre.name = "code"
        pre["class"] = "matlab"
        pre.wrap(soup.new_tag("pre"))
        # erase span elements
        for e in pre:
            if isinstance(e,Tag):
                e.unwrap()

    # Remove all errors
    for pre in content.find_all("pre", class_="error"):
        pre.extract()

    # Format simple preformatted text
    # <pre>
    pres = content.find_all(criteria_simplepre)
    for pre in pres:
        pre["class"] = "preformatted"

    # Format Matlab's output (codeoutput)
    # <pre class="codeoutput">
    outs = content.find_all("pre", class_="codeoutput")
    for out in outs:
        new_tag = soup.new_tag("h6")
        new_tag.string = "Output:"
        out.insert_before(new_tag)

    # Format Matlab's output (codeoutput) with latex content
    # <pre class="codeoutput">\begin{align}\end{align}</pre>
    outs = content.find_all("pre", class_="codeoutput", string=re.compile("\s*\\\\begin{align}.*\\\\end{align}\s*", re.MULTILINE | re.DOTALL))
    #outs = content.find_all("pre", class_="codeoutput", string=re.compile("\s*\\begin{align}.*\\end{align}\s*"))
    for out in outs:
        out.previous_sibling.previous_sibling.extract()
        out.previous_sibling.extract()
        new_tag = out.string
        out.insert_before(new_tag)
        out.extract()

    # Format footer
    # <p class="footer">
    footer = content.find_all("p", class_="footer")
    if len(footer) > 0:
        footer = footer[-1]
        for br in footer.find_all('br'):
            br.extract()
        if footer.has_attr("class"):
            footer["class"] = "footer-matlab"

        lnksoup = soup.new_tag("a")
        lnksoup["href"] = "https://www.crummy.com/software/BeautifulSoup/bs4/doc/"
        lnksoup.string = "BeautifulSoup"

        lnkgithub = soup.new_tag("a")
        lnkgithub["href"] = "https://github.com/ppolcz/demonstrations/blob/master/lib/python/matlab_html_sanitizer.py"
        lnkgithub.string = "Python script"

        footer.append(", and sanitarized by ")
        footer.append(lnksoup)
        footer.append(" (")
        footer.append(lnkgithub)
        footer.append(" using BSoup is written by Polcz).")

    # Matlab figures: change img source with php tag
    imgs = content.find_all("img")
    for img in imgs:
        img["src"] = "<?php echo \"$media\"; ?>/" + img["src"]
        img["class"] = "matlabfig"
        datagal = soup.new_tag('a')
        datagal["href"] = img["src"]
        datagal["data-gallery"] = ""

        img.wrap(datagal)
        img.insert_before(NavigableString("\n    "))
        datagal.append("\n")
        # img.replace_with(datagal)

    toc = content.find_all("h2", string="Contents", limit=1)
    if toc:
        toc = toc[0]
        toc_div = toc.find_all_next("div", limit=1)[0]
        toc.extract()
        toc_div.extract()

    h2s = content.find_all("h2")
    for h2 in h2s:
        if h2.has_attr("class"):
            h2['class'] = h2['class'] + " nocount";
        else:
            h2['class'] = "nocount";
        if h2.next_sibling and h2.next_sibling.name == "h2":
            h2.name = "h1";

    h2s = content.find_all("a", href="EXTRACT-THIS")
    for a in h2s:
        h2 = a.parent
        if h2.next_sibling.name == "pre" and h2.next_sibling.has_attr("class") and h2.next_sibling["class"] == "preformatted":
            h2.next_sibling.extract()
            h2.extract()

    h2s = content.find_all("a", href="EXTRACT-IO")
    for a in h2s:
        h2 = a.parent
        code = h2.next_sibling
        output_title = code.next_sibling
        output = output_title.next_sibling
        if code.name == "pre" and code.has_attr("class") and code["class"] == "preformatted" and output_title.name == "h6":
            output.extract()
            output_title.extract()
            code.extract()
            h2.extract()

    h2s = content.find_all("a", href="EXTRACT-OUTPUT")
    for a in h2s:
        h2 = a.parent
        code = h2.next_sibling
        output_title = code.next_sibling
        output = output_title.next_sibling
        if code.name == "pre" and code.has_attr("class") and code["class"] == "preformatted" and output_title.name == "h6":
            output.extract()
            output_title.extract()


    # Detect request for video`
    revid = re.compile("vid\d{4}\.webm");
    for pre_with_vid in content.find_all("pre", attrs="codeoutput", string=revid):
        # print(pre_with_vid)
        # print(pre_with_vid.string)

        vidname = revid.findall(pre_with_vid.string)[0]
        # print(vidname)

        # <source src="<?php echo "$media"; ?>/vid1878.webm" type='video/webm; codecs="vp8.0, vorbis"'>
        source = soup.new_tag("source")
        source["src"] = '<?php echo "$media"; ?>/' + vidname
        source["type"] = 'video/webm; codecs="vp8.0, vorbis"'
        # print(source)

        # <video width="620" style="max-width:100%" poster="" controls></video>
        video = soup.new_tag("video")
        video["width"] = "620"
        video["style"] = "max-width:100%"
        video["poster"] = ""
        video["controls"] = ""
        video.append("\n    ")
        video.append(source)
        video.append("\n    Your browser does not support the video tag.\n")
        # print(video)

        if pre_with_vid.previous_element.parent.name == "h6":
            pre_with_vid.previous_element.parent.extract()

        pre_with_vid.insert_after(video)
        print(pre_with_vid)
        pre_with_vid.extract()

    # Remove the beginning and ending scopes
    for pre_with_TMP in content.find_all(string=re.compile("TMP_[a-zA-Z0-9]{20}")):
        # print(pre_with_TMP.parent)

        if pre_with_TMP.parent.parent and pre_with_TMP.parent.parent.name == "pre":
            pre_with_TMP.parent.parent.extract()

    # html = content.prettify('utf8').replace('&lt;?php', '<?php').replace('?&gt;','?>')
    # html = content.encode('utf8').replace('&lt;?php', '<?php').replace('?&gt;','?>')

    html = "\n\n".join([ e.encode("utf8") for e in content ]).replace('&lt;?php', '<?php').replace('?&gt;','?>')
    #print(html)

    f.write(html)

if __name__ == "__main__":
    if len(sys.argv) >= 7:
        main(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5], sys.argv[6])
    elif len(sys.argv) >= 6:
        main(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5])
    elif len(sys.argv) >= 5:
        main(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4])
    elif len(sys.argv) >= 4:
        main(sys.argv[1], sys.argv[2], sys.argv[3])
    elif len(sys.argv) >= 3:
        main(sys.argv[1], sys.argv[2])
    else:
        main("/home/ppolcz/Repositories/Bitbucket/control-systems/oktatas/anal3/4_pde/html/hullamegyenlet_gyenge_megoldasok_v1.html",
            "/home/ppolcz/Repositories/Bitbucket/control-systems/oktatas/anal3/4_pde/html/hullamegyenlet_gyenge_megoldasok_v1_output.html")

    # demo()


