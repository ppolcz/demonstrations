#!/usr/bin/python

from HTMLParser import HTMLParser
from bs4 import BeautifulSoup
from bs4 import element
from pathlib import Path

import sys

# create a subclass and override the handler methods
class MyHTMLParser(HTMLParser):
    def handle_starttag(self, tag, attrs):
        print "Encountered a start tag:", tag

    def handle_endtag(self, tag):
        print "Encountered an end tag :", tag

    def handle_data(self, data):
        print "Encountered some data  :", data

contents = open('publish_demo2.html', 'r').read()
# print(contents)

# contents = Path("anal3_vekanal_1.html").read_text()
# print(dir(contents))

# instantiate the parser and fed it some HTML
parser = MyHTMLParser()
parser.feed(contents)

# print(dir(parser))

parser.handle_starttag('a', [('href', 'https://www.cwi.nl/')])

# print(parser.getpos())
# print(parser.get_starttag_text())



soup = BeautifulSoup(contents, "html.parser")
# print(soup.body)

from lxml.html.clean import clean_html

# print(clean_html(soup.body))




import networkx as nx
from lxml import html
import pylab as plt
from networkx.drawing.nx_agraph import graphviz_layout
import matplotlib.pyplot as plt

def traverse(parent, graph, labels):
    labels[parent] = parent.tag
    for node in parent.getchildren():
        graph.add_edge(parent, node)
        traverse(node, graph, labels)

G = nx.DiGraph()
labels = {}     # needed to map from node to tag
html_tag = html.document_fromstring(clean_html(str(soup.body.div)))
traverse(html_tag, G, labels)

pos = graphviz_layout(G, prog='dot')

label_props = {'size': 8,
               'color': 'black',
               'weight': 'bold',
               'horizontalalignment': 'center',
               'verticalalignment': 'center',
               'clip_on': True}
bbox_props = {'boxstyle': "round, pad=0.1",
              'fc': "grey",
              'ec': "b",
              'lw': 1.2}

nx.draw_networkx_edges(G, pos, arrows=False)
ax = plt.gca()

for node, label in labels.items():
    x, y = pos[node]
    ax.text(x, y, label,
        bbox=bbox_props,
        **label_props)

ax.xaxis.set_visible(False)
ax.yaxis.set_visible(False)
# plt.show()




# print(dir(soup.body))
print(str(soup.body.div.div))


print(soup.body.div.div.find_all('a'))
print(type(soup))
print(type(soup.body))
print(type(soup.body.div.div))
print(soup.body.div['class'][0])



if soup.body.div['class'][0] == 'content':
    print("[  OK  ] body.div.class is content")

i = 0;
for x in soup.body.div:
    i = i+1
    if isinstance(x,element.Tag):

        if x.name == 'pre':
            print(' ')
            try:
                if 'codeinput' in x['class'] or 'language-matlab' in x['class']:
                    sys.stdout.write('<pre><code class="matlab smargin">')
                elif 'codeoutput' in x['class']:
                    print('<h6>OUTPUT</h6>')
                    sys.stdout.write('<pre class="codeoutput">')
            except:
                sys.stdout.write('<pre class="simplecode">')

            for y in x:
                if isinstance(y,element.Tag):
                    for z in y.children:
                        sys.stdout.write(z)
                else:
                    sys.stdout.write(y)

            try:
                if 'codeinput' in x['class'] or 'language-matlab' in x['class']:
                    sys.stdout.write('</code></pre>')
                elif 'codeoutput' in x['class']:
                    sys.stdout.write('</pre>')
            except:
                sys.stdout.write('</pre>')
        elif x.name == "p":
            sys.stdout.write('<p ')
            for key,vals in x.attrs.iteritems():
                sys.stdout.write(str(key) + '="')
                sys.stdout.write(str(vals[0]))

                vals = vals[2:]
                for val in vals:
                    sys.stdout.write(" " + str(val))
                sys.stdout.write('" ')
            sys.stdout.write('>')

            for y in x:
                if y.name == "img" and y.has_attr('alt') and y["alt"]:
                    sys.stdout.write(y["alt"])
                else:
                    sys.stdout.write(str(y))
            sys.stdout.write('</p>')
        else:
            # try:
            #     for y in x:
            #         print(y)
            #         if y.name == 'img' and y['alt']:
            #             print y["alt"]
            # except:
            print(' ')
            print(x)
            # if 'img' in str(x):
            #     print('IMG TAG')