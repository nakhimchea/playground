import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart' as gh_theme;
import 'package:flutter_highlight/themes/monokai-sublime.dart' as mk_theme;
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:markdown/markdown.dart' as md;

class CustomMarkdown extends StatelessWidget {
  const CustomMarkdown(this.source, {super.key, this.localeAware = false});

  final String source;
  final bool localeAware;

  @override
  Widget build(BuildContext context) {
    var txt = source.replaceAll('\r\n', '\n');
    txt = txt.replaceAllMapped(
      RegExp(r'\\\[\s*([\s\S]+?)\s*\\\]', multiLine: true),
      (m) => '\$\$\n${m[1]}\n\$\$',
    );

    final theme = Theme.of(context);
    final textTheme = localeAware ? theme.primaryTextTheme : theme.textTheme;
    final base = textTheme.bodyMedium!;
    final nodes = md.Document(encodeHtml: false).parseLines(txt.split('\n'));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [for (var i = 0; i < nodes.length; i++) ..._block(nodes[i], context, base, textTheme)],
    );
  }

  List<Widget> _block(md.Node node, BuildContext ctx, TextStyle base, TextTheme t) {
    if (node is! md.Element) return [];
    if (node.tag == 'p') {
      final display = _asDisplayMath(node.textContent.trim());
      if (display != null) {
        return [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Math.tex(display, mathStyle: MathStyle.display, textStyle: base),
            ),
          )
        ];
      }
    }
    switch (node.tag) {
      case 'p':
        return [_paragraph(node, ctx, base)];
      case 'ul':
        return _list(node, ctx, base, numbered: false);
      case 'ol':
        return _list(node, ctx, base, numbered: true);
      case 'h1':
        return [_heading(node, _scale(t.titleLarge ?? base))];
      case 'h2':
        return [_heading(node, _scale(t.titleMedium ?? base))];
      case 'h3':
        return [_heading(node, _scale(t.titleSmall ?? base))];
      case 'pre':
        return [_codeBlock(node, ctx, t)];
    }
    return [];
  }

  Widget _paragraph(md.Element p, BuildContext ctx, TextStyle base) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text.rich(TextSpan(children: _inline(p, ctx, base))),
      );

  TextStyle _scale(TextStyle s) => s.copyWith(fontSize: (s.fontSize ?? 16));

  Widget _heading(md.Element h, TextStyle style) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(h.textContent, style: style),
      );

  List<Widget> _list(md.Element listEl, BuildContext ctx, TextStyle base, {required bool numbered}) {
    final out = <Widget>[];
    var idx = 1;
    for (final li in listEl.children ?? []) {
      out.add(
        Padding(
          padding: const EdgeInsets.only(left: 12, bottom: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(numbered ? '${idx++}. ' : '• '),
              Expanded(
                child: Text.rich(
                  TextSpan(children: _inline(_unwrap(li), ctx, base)),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return out;
  }

  md.Element _unwrap(md.Element li) {
    if (li.children?.length == 1 && li.children!.first is md.Element) {
      final child = li.children!.first as md.Element;
      if (child.tag == 'p') return child;
    }
    return li;
  }

  Widget _codeBlock(md.Element pre, BuildContext ctx, TextTheme t) {
    final codeEl = pre.children!.first as md.Element;
    final langClass = codeEl.attributes['class'];
    final lang = langClass?.startsWith('language-') == true ? langClass!.substring(9) : 'plaintext';
    final codeText = codeEl.textContent.trimRight();
    final isDark = Theme.of(ctx).brightness == Brightness.dark;
    final baseSize = (t.bodyMedium ?? const TextStyle(fontSize: 14)).fontSize!;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF23241F) : const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: HighlightView(
        codeText,
        language: lang,
        theme: isDark ? mk_theme.monokaiSublimeTheme : gh_theme.githubTheme,
        textStyle: TextStyle(fontFamily: 'monospace', fontSize: baseSize),
      ),
    );
  }

  List<InlineSpan> _inline(md.Element root, BuildContext ctx, TextStyle base) {
    final spans = <InlineSpan>[];
    for (final n in root.children ?? []) {
      if (n is md.Text) {
        spans.addAll(_splitInlineMath(n.text, base));
      } else if (n is md.Element) {
        switch (n.tag) {
          case 'strong':
            spans.add(TextSpan(children: _inline(n, ctx, base.copyWith(fontWeight: FontWeight.w700))));
            break;
          case 'em':
            spans.add(TextSpan(children: _inline(n, ctx, base.copyWith(fontStyle: FontStyle.italic))));
            break;
          case 'code':
            final small = base.copyWith(
              fontFamily: 'monospace',
              fontSize: (base.fontSize ?? 14) * .8,
            );
            spans.add(WidgetSpan(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color:
                      Theme.of(ctx).brightness == Brightness.dark ? const Color(0xFF303030) : const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(n.textContent, style: small),
              ),
            ));
            break;
          default:
            spans.addAll(_inline(n, ctx, base));
        }
      }
    }
    return spans;
  }

  String? _asDisplayMath(String txt) {
    final m = RegExp(r'^\$\$\s*([\s\S]+?)\s*\$\$$').firstMatch(txt);
    return m?.group(1);
  }

  List<InlineSpan> _splitInlineMath(String text, TextStyle style) {
    const patt = r'(\$+)\s*([^\$]+?)\s*\1|\\\((.+?)\\\)';
    final spans = <InlineSpan>[];
    var idx = 0;
    for (final m in RegExp(patt).allMatches(text)) {
      if (m.start > idx) {
        spans.add(TextSpan(text: text.substring(idx, m.start), style: style));
      }
      final latex = (m.group(2) ?? m.group(3) ?? '').trim();
      spans.add(WidgetSpan(
        alignment: PlaceholderAlignment.baseline,
        baseline: TextBaseline.alphabetic,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Math.tex(latex, mathStyle: MathStyle.text, textStyle: style),
        ),
      ));
      idx = m.end;
    }
    if (idx < text.length) {
      spans.add(TextSpan(text: text.substring(idx), style: style));
    }
    return spans;
  }
}
