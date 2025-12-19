// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class L10nJa extends L10n {
  L10nJa([String locale = 'ja']) : super(locale);

  @override
  String get startScreenTitle => 'Edit Snap';

  @override
  String helloWorldOn(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.MEd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'こんにちは！\n今日は$dateStringです';
  }

  @override
  String get start => '開始する';

  @override
  String get imageSelectScreentTitle => '画像を選択';

  @override
  String get imageSelect => '画像を選ぶ';

  @override
  String get imageEdit => '画像を編集する';

  @override
  String get imageSave => '保存する';

  @override
  String get resizeLabel => 'リサイズ';

  @override
  String widthLabel(int width) {
    return '幅: ${width}px';
  }

  @override
  String get saveSuccess => '画像を保存しました';

  @override
  String get saveFailed => '保存に失敗しました';
}
