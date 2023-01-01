import 'package:aus/utils/color_utils.dart';
import 'package:flutter/material.dart';
import '../controllers/post_controller.dart';
import 'package:timeago/timeago.dart' as timeago;

Widget postListView(List<Widget> children) {
  return SingleChildScrollView(
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    ),
  );
}

Widget viewCommentSave(
    BuildContext context, String hexButtonColor, PostController controller) {
  return Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(4, 0, 4, 4),
    child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        //view
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(8, 8, 0, 8),
                child: Icon(
                  Icons.remove_red_eye_outlined,
                  color: hexStringToColor(hexButtonColor),
                  size: 24,
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(4, 0, 4, 0),
                child: Text(
                  'View',
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        fontFamily: 'Outfit',
                        color: hexStringToColor(hexButtonColor),
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(4, 0, 6, 0),
                child: Text(
                  controller.post.views.toString(),
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        fontFamily: 'Outfit',
                        color: hexStringToColor(hexButtonColor),
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                ),
              ),
            ],
          ),
        ),
        //comment
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(8, 8, 0, 8),
                child: Icon(
                  Icons.comment,
                  color: hexStringToColor(hexButtonColor),
                  size: 24,
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(4, 0, 4, 0),
                child: Text(
                  'Comment',
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        fontFamily: 'Outfit',
                        color: hexStringToColor(hexButtonColor),
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(4, 0, 6, 0),
                child: Text(
                  controller.post.comments.length.toString(),
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        fontFamily: 'Outfit',
                        color: hexStringToColor(hexButtonColor),
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                ),
              ),
            ],
          ),
        ),
        //save
        TextButton(
          style:
              TextButton.styleFrom(primary: hexStringToColor(hexButtonColor)),
          onPressed: () {},
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
                  child: Icon(
                    Icons.bookmark_border,
                    color: hexStringToColor(hexButtonColor),
                    size: 24,
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(4, 0, 6, 0),
                  child: Text(
                    'Save',
                    style: Theme.of(context).textTheme.bodyText2?.copyWith(
                          fontFamily: 'Outfit',
                          color: hexStringToColor(hexButtonColor),
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget writerInfoUI(BuildContext context, PostController controller) {
  return Column(children: [
    Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8, 12, 8, 16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: 40,
            height: 40,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Image(
              image: AssetImage('assets/imgs/profile.jpeg'),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                    child: Text(
                      controller.post.category,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontFamily: 'Outfit',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
                    child: Text(
                      "• ${timeago.format(DateTime.now().subtract(DateTime.now().difference(controller.post.timestamp)))}",
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            fontFamily: 'Outfit',
                            color: hexStringToColor("#AAAAAA"),
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                    child: Text(
                      controller.post.writer.name,
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            color: hexStringToColor("#AAAAAA"),
                            fontFamily: 'Outfit',
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
                    child: Text(
                      "• ${controller.getPostWriterSchool()}",
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            fontFamily: 'Outfit',
                            color: hexStringToColor("#AAAAAA"),
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  ]);
}

Widget contentUI(BuildContext context, PostController controller) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 8, 4),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Text(
                controller.post.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontFamily: 'Outfit',
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 8, 4),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Text(
                controller.post.text,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      fontFamily: 'Outfit',
                      color: hexStringToColor("#AAAAAA"),
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget postUI(BuildContext context, PostController controller,
    {Function? setState}) {
  return Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(16, 14, 16, 0),
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        // color: hexStringToColor("#3E3E3E"),
        // boxShadow: const [
        //   BoxShadow(
        //     blurRadius: 5,
        //     color: Color(0x3416202A),
        //     offset: Offset(0, 3),
        //   )
        // ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            writerInfoUI(context, controller),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'post_detail',
                    arguments: {'post': controller.post});
                setState!(controller.incrementView);
              },
              child: contentUI(context, controller),
            ),
            viewCommentSave(context, "#AAAAAA", controller),
            const Divider(
              height: 8,
              thickness: 1,
              indent: 4,
              endIndent: 4,
              color: Color.fromARGB(255, 74, 74, 74),
            ),
          ],
        ),
      ),
    ),
  );
}
