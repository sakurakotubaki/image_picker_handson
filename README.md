# image_picker_handson
このアプリは、Flutter実践開発の学習リポジトリです。

- バージョン管理ツールfvm
- flutter 3.38.1
- dart 3.10.0

**多言語対応あり**

lib/配下に`l10n`ディレクトを作成して、`app_ja.arb`を作成する。

```rb
{
  "@@locale": "ja",
  "startScreenTitle": "Edit Snap",
  "helloWorldOn": "こんにちは！\n今日は{date}です",
  "@helloWorldOn": {
    "placeholders": {
      "date": {
        "type": "DateTime",
        "format": "MEd"
      }
    }
  },
  "start": "開始する"
}
```