import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:playground_1/common_libs.dart';
import 'package:playground_1/logic/data/timeline_data.dart';
import 'package:playground_1/logic/data/wonder_data.dart';
import 'package:playground_1/ui/common/centered_box.dart';
import 'package:playground_1/ui/common/controls/app_header.dart';
import 'package:playground_1/logic/common/string_utils.dart';
import 'package:playground_1/ui/common/utils/app_haptics.dart';
import 'package:playground_1/ui/common/wonders_timeline_builder.dart';
import 'package:playground_1/ui/common/dashed_line.dart';
part 'widgets/_animated_era_text.dart';
part 'widgets/_bottom_scrubber.dart';
part 'widgets/_scrolling_viewport.dart';
part 'widgets/_scrolling_viewport_controller.dart';

class TimelineScreen extends StatefulWidget {
  final WonderType? type;

  const TimelineScreen({super.key, required this.type});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  /// Create a scroll controller that the top and bottom timelines can share
  final ScrollController _scroller = ScrollController();
  final _year = ValueNotifier<int>(0);

  void _handleViewportYearChanged(int value) => _year.value = value;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      // Determine min and max size of the timeline based on the size available to this widget
      const double scrubberSize = 80;
      const double minSize = 1200;
      const double maxSize = 5500;
      return Container(
        color: $styles.colors.black,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: Column(
            children: [
              AppHeader(title: $strings.timelineTitleGlobalTimeline),

              /// Vertically scrolling timeline, manages a ScrollController.
              Expanded(
                child: _ScrollingViewport(
                  scroller: _scroller,
                  minSize: minSize,
                  maxSize: maxSize,
                  selectedWonder: widget.type,
                  onYearChanged: _handleViewportYearChanged,
                ),
              ),

              /// Era Text (classical, modern etc)
              ValueListenableBuilder<int>(
                valueListenable: _year,
                builder: (_, value, __) => _AnimatedEraText(value),
              ),
              Gap($styles.insets.xs),

              /// Mini Horizontal timeline, reacts to the state of the larger scrolling timeline,
              /// and changes the timelines scroll position on Hz drag
              CenteredBox(
                width: $styles.sizes.maxContentWidth1,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: $styles.insets.lg),
                  child: _BottomScrubber(
                    _scroller,
                    size: scrubberSize,
                    timelineMinSize: minSize,
                    selectedWonder: widget.type,
                  ),
                ),
              ),
              Gap($styles.insets.lg),
            ],
          ),
        ),
      );
    });
  }
}
