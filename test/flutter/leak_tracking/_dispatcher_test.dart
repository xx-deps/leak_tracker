// Copyright (c) 2022, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leak_tracker/src/leak_tracking/_dispatcher.dart';

import '../../dart_test_infra/mocks/mock_object_tracker.dart';

void main() {
  test('dispatchObjectEvent dispatches Flutter SDK instrumentation.', () {
    final tracker = MockObjectTracker();
    MemoryAllocations.instance
        .addListener((event) => dispatchObjectEvent(event.toMap(), tracker));

    final picture = _createPicture();

    expect(tracker.events, hasLength(1));
    var event = tracker.events[0];
    tracker.events.clear();
    expect(event.type, EventType.started);
    expect(event.object, picture);
    expect(event.context, null);
    expect(event.trackedClass, 'dart:ui/Picture');

    picture.dispose();

    expect(tracker.events, hasLength(1));
    event = tracker.events[0];
    tracker.events.clear();
    expect(event.type, EventType.disposed);
    expect(event.object, picture);
    expect(event.context, null);
  });
}

Picture _createPicture() {
  final PictureRecorder recorder = PictureRecorder();
  final Canvas canvas = Canvas(recorder);
  const Rect rect = Rect.fromLTWH(0.0, 0.0, 100.0, 100.0);
  canvas.clipRect(rect);
  return recorder.endRecording();
}
