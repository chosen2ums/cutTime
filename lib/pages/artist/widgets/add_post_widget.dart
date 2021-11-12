import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:salon/helper/helper.dart';
import 'package:salon/helper/loading.dart';
import 'package:salon/provider/artist_state_provider.dart';
import 'package:salon/repository.dart';
import 'package:shape_of_view/shape_of_view.dart';

import 'add_photo.dart';
import 'photo_widget.dart';

class AddPostWidget extends StatefulWidget {
  AddPostWidget({Key key}) : super(key: key);

  @override
  _AddPostWidgetState createState() => _AddPostWidgetState();
}

class _AddPostWidgetState extends State<AddPostWidget> {
  PageController controller;

  @override
  void initState() {
    controller = PageController(initialPage: 0, viewportFraction: 0.9);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ArtistStateProvider val = Provider.of(context);
    return WillPopScope(
      onWillPop: Helper.of(context).backPage,
      child: Material(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: repo.statusBar + 50,
                bottom: 70,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: (MediaQuery.of(context).size.width * 0.8) * 1.4,
                        child: PageView.builder(
                          controller: controller,
                          itemCount: val.photos.length + 1,
                          itemBuilder: (context, index) {
                            if (index == val.photos.length)
                              return AddPhoto();
                            else
                              return PhotoWidget(val.photos.elementAt(index));
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      ShapeOfView(
                        shape: RoundRectShape(borderRadius: BorderRadius.circular(8)),
                        elevation: 1,
                        child: TextFormField(
                          maxLines: 7,
                          keyboardType: TextInputType.text,
                          textAlignVertical: TextAlignVertical.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).hintColor.withOpacity(0.8),
                          ),
                          onChanged: val.changeTitle,
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            hintText: "Write a title",
                            contentPadding: EdgeInsets.all(10),
                            fillColor: Theme.of(context).colorScheme.background,
                            hintStyle: TextStyle(
                              fontSize: 13,
                              color: Theme.of(context).hintColor.withOpacity(0.6),
                            ),
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'Post as',
                            style: TextStyle(
                              color: Theme.of(context).hintColor.withOpacity(0.75),
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              shadows: [
                                Shadow(
                                  blurRadius: 5,
                                  color: Colors.black12,
                                  offset: Offset(0, 3),
                                )
                              ],
                            ),
                          ),
                          Spacer(),
                          SizedBox(
                            width: 120,
                            height: 30,
                            child: InkWell(
                              onTap: () => val.setOwner(true),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.background,
                                  border: Border.all(
                                    color: val.post.owner == val.ownersalon
                                        ? Theme.of(context).colorScheme.secondaryVariant
                                        : Theme.of(context).scaffoldBackgroundColor,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 4,
                                      color: Colors.black12,
                                    )
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Салон өмчлөх',
                                  style: TextStyle(
                                    color: Theme.of(context).hintColor,
                                    fontWeight: val.post.owner == val.ownersalon ? FontWeight.w600 : FontWeight.w300,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          SizedBox(
                            width: 120,
                            height: 30,
                            child: InkWell(
                              onTap: () => val.setOwner(false),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.background,
                                  border: Border.all(
                                    color: val.post.owner == val.ownerme
                                        ? Theme.of(context).colorScheme.secondaryVariant
                                        : Theme.of(context).scaffoldBackgroundColor,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 2,
                                      color: Colors.black12,
                                    )
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Өөрөө өмчлөх',
                                  style: TextStyle(
                                    color: Theme.of(context).hintColor,
                                    fontWeight: val.post.owner == val.ownerme ? FontWeight.w600 : FontWeight.w300,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Divider(height: 40),
                      // Text(
                      //   'Tags',
                      //   style: TextStyle(
                      //     color: Theme.of(context).hintColor.withOpacity(0.75),
                      //     fontSize: 16,
                      //     fontWeight: FontWeight.w800,
                      //     shadows: [
                      //       Shadow(
                      //         blurRadius: 5,
                      //         color: Colors.black12,
                      //         offset: Offset(0, 3),
                      //       )
                      //     ],
                      //   ),
                      // ),
                      // SizedBox(height: 10),
                      // Wrap(
                      //   direction: Axis.horizontal,
                      //   spacing: 10,
                      //   runSpacing: 5,
                      //   alignment: WrapAlignment.start,
                      //   runAlignment: WrapAlignment.start,
                      //   crossAxisAlignment: WrapCrossAlignment.start,
                      //   children: List.generate(
                      //     val.me.services.length,
                      //     (index) => InkWell(
                      //       onTap: () => val.handleTags(
                      //         val.me.services.elementAt(index),
                      //       ),
                      //       child: Container(
                      //         decoration: BoxDecoration(
                      //           color: Theme.of(context).colorScheme.background,
                      //           borderRadius: BorderRadius.circular(8),
                      //           border: Border.all(
                      //             color: val.post.tags.indexWhere((element) => element.name == val.me.services.elementAt(index).name).isNegative
                      //                 ? Theme.of(context).scaffoldBackgroundColor
                      //                 : Theme.of(context).colorScheme.secondaryVariant,
                      //           ),
                      //           boxShadow: [
                      //             BoxShadow(
                      //               blurRadius: 1,
                      //               color: Colors.black12,
                      //             )
                      //           ],
                      //         ),
                      //         padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
                      //         child: Text('${val.me.services.elementAt(index).name}'),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 40,
                child: Divider(height: 40),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: val.backPost,
                      visualDensity: VisualDensity.compact,
                      icon: Icon(Ionicons.return_down_back_outline),
                    ),
                    TextButton(
                      onPressed: val.savePost,
                      child: Text('Post'),
                      style: ButtonStyle(
                        visualDensity: VisualDensity.compact,
                        shape: MaterialStateProperty.all(StadiumBorder()),
                        backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.secondary,
                        ),
                        foregroundColor: MaterialStateProperty.all(Colors.white),
                        padding: MaterialStateProperty.all(EdgeInsets.fromLTRB(40, 15, 40, 15)),
                        textStyle: MaterialStateProperty.all(TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
              val.loading
                  ? Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.black26,
                        child: Loading(20),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
