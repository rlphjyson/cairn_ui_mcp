import '../index/cairn_index.dart';
import '../index/models.dart';

/// One ranked hit.
class Hit {
  Hit(this.component, this.score, this.reasons);

  final Component component;
  final double score;

  /// Why it matched, e.g. `name`, `description: modal`.
  final List<String> reasons;
}

/// Words people use that are not the component's own name.
const Map<String, List<String>> synonyms = <String, List<String>>{
  'modal': <String>['dialog', 'alert dialog', 'sheet'],
  'popup': <String>['popover', 'dialog', 'tooltip'],
  'confirm': <String>['alert dialog', 'dialog'],
  'snackbar': <String>['toast'],
  'notification': <String>['toast', 'alert', 'indicator', 'badge'],
  'banner': <String>['alert', 'hero'],
  'dropdown': <String>['select', 'dropdown menu', 'combobox', 'menu'],
  'picker': <String>['select', 'date picker', 'combobox', 'calendar'],
  'autocomplete': <String>['combobox', 'command'],
  'search': <String>['command', 'combobox', 'input'],
  'palette': <String>['command'],
  'tab': <String>['tabs'],
  'navbar': <String>['navbar', 'navigation menu', 'menubar'],
  'navigation': <String>[
    'navbar',
    'dock',
    'navigation menu',
    'breadcrumb',
    'tabs',
    'pagination',
  ],
  'bottom': <String>['dock', 'sheet'],
  'sidebar': <String>['sheet', 'drawer', 'menu'],
  'drawer': <String>['drawer', 'sheet'],
  'loading': <String>['spinner', 'skeleton', 'progress', 'radial progress'],
  'spinner': <String>['spinner'],
  'placeholder': <String>['skeleton', 'empty'],
  'progress': <String>['progress', 'radial progress', 'steps'],
  'step': <String>['steps'],
  'stepper': <String>['steps'],
  'checkout': <String>['steps'],
  'wizard': <String>['steps'],
  'checkbox': <String>['checkbox', 'toggle', 'switch'],
  'toggle': <String>['switch', 'toggle', 'toggle group', 'checkbox'],
  'radio': <String>['radio group'],
  'range': <String>['slider'],
  'upload': <String>['file input'],
  'file': <String>['file input'],
  'otp': <String>['input otp'],
  'password': <String>['input', 'input otp'],
  'form': <String>['form field', 'input', 'label', 'select', 'checkbox'],
  'field': <String>['form field', 'input', 'label'],
  'text': <String>['input', 'textarea', 'label'],
  'table': <String>['table', 'data table'],
  'grid': <String>['data table', 'table', 'list'],
  'list': <String>['list', 'menu', 'table'],
  'chart': <String>['stat', 'radial progress', 'progress'],
  'metric': <String>['stat', 'radial progress'],
  'kpi': <String>['stat'],
  'dashboard': <String>['stat', 'data table', 'card', 'sheet'],
  'card': <String>['card', 'hero'],
  'avatar': <String>['avatar', 'indicator', 'stack'],
  'badge': <String>['badge', 'indicator', 'status'],
  'chip': <String>['badge', 'toggle'],
  'tag': <String>['badge'],
  'rating': <String>['rating'],
  'stars': <String>['rating'],
  'review': <String>['rating', 'chat bubble'],
  'chat': <String>['chat bubble', 'list'],
  'message': <String>['chat bubble', 'alert', 'toast'],
  'tooltip': <String>['tooltip', 'hover card'],
  'hint': <String>['tooltip', 'popover'],
  'context': <String>['context menu'],
  'rightclick': <String>['context menu'],
  'accordion': <String>['accordion', 'collapsible'],
  'expand': <String>['accordion', 'collapsible'],
  'collapse': <String>['collapsible', 'accordion'],
  'carousel': <String>['carousel'],
  'slider': <String>['slider', 'carousel'],
  'date': <String>['date picker', 'calendar'],
  'time': <String>['countdown', 'date picker', 'timeline'],
  'timer': <String>['countdown'],
  'history': <String>['timeline', 'list'],
  'activity': <String>['timeline'],
  'compare': <String>['diff'],
  'delete': <String>['alert dialog', 'dialog'],
  'remove': <String>['alert dialog', 'dialog'],
  'header': <String>['navbar', 'hero', 'card'],
  'landing': <String>['hero', 'navbar', 'stat'],
  'phone': <String>['mockup', 'dock'],
  'floating': <String>['fab'],
  'button': <String>['button', 'fab', 'link'],
  'link': <String>['link', 'button'],
  'shortcut': <String>['kbd'],
  'keyboard': <String>['kbd'],
  'divider': <String>['separator'],
  'empty': <String>['empty'],
  'scroll': <String>['scroll area'],
  'aspect': <String>['aspect ratio'],
  'swap': <String>['swap', 'toggle'],
  'online': <String>['status', 'indicator'],
  'status': <String>['status', 'badge', 'indicator'],
};

/// Ranks components against a free-text query.
List<Hit> searchComponents(CairnIndex index, String query, {int limit = 8}) {
  final List<String> terms = _tokens(query);
  if (terms.isEmpty) return const <Hit>[];

  final Map<String, double> boost = <String, double>{};
  for (final String t in terms) {
    for (final String s in synonyms[t] ?? const <String>[]) {
      boost[s] = (boost[s] ?? 0) + 6;
    }
  }

  final List<Hit> hits = <Hit>[];
  for (final Component c in index.components) {
    double score = 0;
    final List<String> reasons = <String>[];
    final String name = c.name.toLowerCase();
    final String slug = c.slug.toLowerCase();
    final String desc = c.description.toLowerCase();
    final String note = (c.note ?? '').toLowerCase();
    final String widgets = c.widgetNames.join(' ').toLowerCase();
    final String variants = c.variants
        .map((Variant v) => v.label)
        .join(' ')
        .toLowerCase();
    final String api = _apiText(c);

    for (final String t in terms) {
      if (name == t || slug == t) {
        score += 12;
        reasons.add('name');
      } else if (name.contains(t) || slug.contains(t)) {
        score += 8;
        reasons.add('name');
      }
      if (widgets.contains(t)) score += 4;
      if (desc.contains(t)) {
        score += 3;
        reasons.add('description: $t');
      }
      if (note.contains(t)) score += 1.5;
      if (variants.contains(t)) score += 1.5;
      if (api.contains(t)) score += 0.5;
    }
    for (final MapEntry<String, double> e in boost.entries) {
      if (name == e.key || slug == e.key.replaceAll(' ', '-')) {
        score += e.value;
        reasons.add('related: ${e.key}');
      }
    }
    if (score > 0) hits.add(Hit(c, score, reasons.toSet().toList()));
  }
  hits.sort((Hit a, Hit b) => b.score.compareTo(a.score));
  return hits.take(limit).toList();
}

String _apiText(Component c) {
  final ApiModule? m = c.module;
  if (m == null) return '';
  final StringBuffer b = StringBuffer();
  for (final ApiClass cls in m.classes) {
    b.write(' ${cls.doc}');
    for (final ApiConstructor ctor in cls.constructors) {
      for (final ApiParam p in ctor.params) {
        b.write(' ${p.name} ${p.doc}');
      }
    }
  }
  for (final ApiEnum e in m.enums) {
    b.write(' ${e.name} ${e.values.map((EnumValue v) => v.name).join(' ')}');
  }
  return b.toString().toLowerCase();
}

const Set<String> _stop = <String>{
  'a',
  'an',
  'the',
  'i',
  'to',
  'for',
  'of',
  'in',
  'on',
  'with',
  'and',
  'or',
  'need',
  'want',
  'how',
  'do',
  'can',
  'use',
  'make',
  'build',
  'create',
  'add',
  'show',
  'that',
  'my',
  'is',
  'it',
  'as',
  'by',
  'at',
  'from',
  'some',
  'get',
};

List<String> _tokens(String q) => <String>[
  for (final String t in q.toLowerCase().split(RegExp(r'[^a-z0-9]+')))
    if (t.length > 1 && !_stop.contains(t)) _singular(t),
];

String _singular(String t) {
  if (t.endsWith('ies') && t.length > 4) {
    return '${t.substring(0, t.length - 3)}y';
  }
  if (t.endsWith('s') && !t.endsWith('ss') && t.length > 3) {
    return t.substring(0, t.length - 1);
  }
  return t;
}
