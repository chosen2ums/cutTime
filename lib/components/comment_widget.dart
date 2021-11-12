import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:salon/models/post.dart';
import 'package:salon/provider/app_provider.dart' as app;
import 'package:salon/repository.dart';
import 'package:shape_of_view/shape_of_view.dart';

class CommentWidget extends StatefulWidget {
  final Post post;
  CommentWidget(this.post);

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  TextEditingController controller = new TextEditingController();
  final FocusNode focus = FocusNode();
  int maxlines = 2;

  handleShow() {
    setState(() {
      if (maxlines == 2)
        maxlines = 30;
      else
        maxlines = 2;
    });
  }

  add() {
    widget.post.addComment(controller.text.trim());
    controller.clear();
    focus.unfocus();
  }

  @override
  void initState() {
    focus.unfocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    app.AppProvider provider = Provider.of(context);
    return Container(
      height: MediaQuery.of(context).size.height - repo.statusBar,
      child: Column(
        children: [
          SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).hintColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(5),
            ),
            width: 200,
            height: 5,
          ),
          InkWell(
            onTap: handleShow,
            child: Padding(
              padding: EdgeInsets.fromLTRB(17, 20, 20, 10),
              child: Row(
                children: [
                  ShapeOfView(
                    shape: CircleShape(
                      borderColor: Colors.white,
                      borderWidth: 1,
                    ),
                    child: CachedNetworkImage(
                      imageUrl: widget.post.owner.logo?.path ?? repo.empty,
                      fit: BoxFit.cover,
                      height: 45,
                      width: 45,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.post.owner.name}',
                          style: TextStyle(
                            color: Theme.of(context).hintColor.withOpacity(0.4),
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          widget.post.body.trim(),
                          maxLines: maxlines,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            color: Theme.of(context).hintColor.withOpacity(0.8),
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(height: 10),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: AnimatedList(
                    shrinkWrap: true,
                    key: widget.post.key,
                    padding: EdgeInsets.only(bottom: 15),
                    initialItemCount: widget.post.comments.length,
                    itemBuilder: widget.post.slideChild,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        color: Colors.black26,
                      )
                    ],
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: TextField(
                      controller: controller,
                      autofocus: false,
                      focusNode: focus,
                      textAlignVertical: TextAlignVertical.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).hintColor.withOpacity(0.8),
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5),
                        isDense: true,
                        prefixIcon: Padding(
                          padding: EdgeInsets.fromLTRB(5, 5, 10, 5),
                          child: ShapeOfView(
                            shape: CircleShape(
                              borderColor: Colors.white,
                              borderWidth: 1,
                            ),
                            child: CachedNetworkImage(
                              imageUrl:
                                  provider.user.avatar?.path ?? repo.empty,
                              height: 40,
                              width: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        suffixIcon: IconButton(
                          onPressed: add,
                          icon: Icon(
                            Ionicons.send,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).scaffoldBackgroundColor,
                        hintText: "Сэтгэгдэл үлдээх...",
                        hintStyle: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).hintColor.withOpacity(0.6),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.background),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.background),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).viewInsets.bottom)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
