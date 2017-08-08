#!/usr/bin/python

import sys, re

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

def main(ipath = "/home/ppolcz/Repositories/Bitbucket/control-systems/demonstrations/oktatas/anal3/html/anal3_vekanal_1.html",
         opath = "/home/ppolcz/Repositories/Bitbucket/control-systems/html/publish_demo2_output.html"):
    contents = open(ipath, 'r').read()
    f = open(opath, 'w')

    soup = BeautifulSoup(contents, "html.parser")
    content = soup.find_all("div", class_="content", limit=1)[0]

    # print(type(content))
    # print(dir(content))

    # Remove all comments
    for element in content(text=lambda text: isinstance(text, Comment)):
        element.extract()

    # Replace prerendered latex images with their latex code
    imgs = content.find_all(criteria_imglatex)
    for img in imgs:
        img.replace_with(img["alt"])

    # Format Matlab code
    pres = content.find_all("pre", class_=re.compile("(codeinput|language-matlab)"))
    for pre in pres:
        pre.name = "code"
        pre["class"] = "matlab"
        pre.wrap(soup.new_tag("pre"))
        # erase span elements
        for e in pre:
            if isinstance(e,Tag):
                e.unwrap()

    # Format simple preformatted text
    pres = content.find_all(criteria_simplepre)
    for pre in pres:
        pre["class"] = "preformatted"

    # Format Matlab's output (codeoutput)
    outs = content.find_all("pre", class_="codeoutput")
    for out in outs:
        new_tag = soup.new_tag("h6")
        new_tag.string = "Output:"
        out.insert_before(new_tag)

    # Format footer
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

    # html = content.prettify('utf8').replace('&lt;?php', '<?php').replace('?&gt;','?>')
    # html = content.encode('utf8').replace('&lt;?php', '<?php').replace('?&gt;','?>')

    html = "\n\n".join([ e.encode("utf8") for e in content ]).replace('&lt;?php', '<?php').replace('?&gt;','?>')
    print(html)

    f.write(html)

if __name__ == "__main__":
    if len(sys.argv) >= 3:
        main(sys.argv[1], sys.argv[2])
    else:
        main()

    # demo()


