import 'package:flutter/material.dart';
import 'package:flutter_markdown_selectionarea/flutter_markdown.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:markdown/markdown.dart' as md;

class CodeElementBuilder extends MarkdownElementBuilder {
  // To determine whether the code is an inline code block or a code block
  bool isCodeBlock(md.Element element) {
    if (element.attributes['class'] != null) {
      return true;
    } else if (element.textContent.contains("\n")) {
      return true;
    }
    return false;
  }

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    if (isCodeBlock(element)) {
      return SyntaxView(
        code: element.textContent,
        syntax: Syntax.DART,
        syntaxTheme: SyntaxTheme.vscodeDark(),
        fontSize: 12.0,
        withZoom: false,
        withLinesCount: false,
        expanded: false,
        selectable: true,
      );
    }
    return Container(
      width: double.infinity,
      color: Colors.grey,
      padding: const EdgeInsets.all(2),
      child: Text(
        element.textContent,
        style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.black),
      ),
    );
  }
}
