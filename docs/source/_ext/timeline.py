from __future__ import annotations

from docutils import nodes
from docutils.nodes import Element, section, title
from sphinx.application import Sphinx
from sphinx.util.docutils import SphinxDirective, SphinxRole
from sphinx.util.typing import ExtensionMetadata
from sphinx.transforms import SphinxTransform


class timeline_node(Element):
    pass


class card_node(section):
    pass


class header_node(Element):
    pass


class TimelineDirective(SphinxDirective):
    has_content = True

    def run(self) -> list[nodes.Node]:
        container = timeline_node()
        self.state.nested_parse(self.content, self.content_offset, container)
        return [container]


class TimelineCardDirective(SphinxDirective):
    """A directive to say hello!"""

    required_arguments = 1
    has_content = True

    def run(self) -> list[nodes.Node]:
        container = card_node()
        container["classes"] = ["terminal-card"]
        container["ids"].append(nodes.make_id(self.arguments[0]))

        # Header element (<header>)
        header = header_node()
        header.append(nodes.Text(self.arguments[0]))
        container += header

        # Content div
        content_div = nodes.container()
        self.state.nested_parse(self.content, self.content_offset, content_div)
        container += content_div

        return [container]


class PromoteTimelineSections(SphinxTransform):
    default_priority = 500

    def apply(self, **kwargs):
        for timeline in self.document.traverse(timeline_node):
            parent = timeline.parent
            index = parent.index(timeline)
            # Move all section children to be siblings of the timeline_node
            sections = [child for child in timeline if isinstance(child, section)]
            for sec in sections:
                timeline.remove(sec)
                parent.insert(index, sec)
                index += 1


def visit_card_node_html(self, node):
    self.body.append('<section class="terminal-card">')


def depart_card_node_html(self, node):
    self.body.append("</section>")


def visit_timeline_node_html(self, node):
    self.body.append('<div class="terminal-timeline">')


def depart_timeline_node_html(self, node):
    self.body.append("</div>")


def visit_header_node_html(self, node):
    self.body.append(self.starttag(node, "header"))


def depart_header_node_html(self, node):
    self.body.append("</header>")


def setup(app: Sphinx) -> ExtensionMetadata:
    app.add_directive("timeline", TimelineDirective)
    app.add_directive("timeline-card", TimelineCardDirective)
    app.add_node(header_node, html=(visit_header_node_html, depart_header_node_html))
    app.add_node(
        card_node,
        html=(visit_card_node_html, depart_card_node_html),
    )

    app.add_node(
        timeline_node,
        html=(visit_timeline_node_html, depart_timeline_node_html),
    )

    # app.add_transform(PromoteTimelineSections)

    return {
        "version": "0.1",
        "parallel_read_safe": True,
        "parallel_write_safe": True,
    }
