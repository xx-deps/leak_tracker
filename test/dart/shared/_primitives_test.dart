// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:leak_tracker/src/shared/_primitives.dart';
import 'package:test/test.dart';

import '../../dart_test_infra/utils.dart';

void main() {
  for (final link in Links.values) {
    test('$link is not broken', () async {
      final content = await loadPageHtmlContent(link.value);
      final hash = link.hash;
      if (hash != null) {
        expect(content, contains('href="#$hash"'));
      }
    });
  }
}
