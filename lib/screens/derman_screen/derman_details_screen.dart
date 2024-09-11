import 'package:dert/screens/dashboard_screen/widgets/dert_appbar.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';

class DermanDetailsScreen extends StatelessWidget {
  const DermanDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint(ScreenUtil.getHeight(context).toString());
    return Scaffold(
      appBar: DertAppbar(
        title: DertText.dert,
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: ScreenUtil.getHeight(context) * 0.33,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ScreenPadding.padding16px,
                  vertical: ScreenPadding.padding32px,
                ),
                child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _dertLogo(),
                          _dertLogo(),
                          _dertLogo(),
                          _dertLogo(),
                          _dertLogo(),
                        ],
                      ),
                      SizedBox(width: ScreenPadding.padding8px),
                      Expanded(
                        child: Text(
                          "sadkjashdsajhdkasdhkasjdhksjdhasjdhasjdhaskdjhskjdhksjdhasdkjhaskdjhsajdhjsdhjsdhjsdhksjdhkjshdkjsdhkjsdhsjadhkjasdhjasdhajsdhasjdhjsdhskjdhjsdhjsadhkjasdhaskjdhkajshdkajsdhjkashdjkashdjkasdhjkasdhjasdhksajdhaskdjhasjdhsajdhasjdkhaskjdhsajdhsajdhsakdjhsajdhsjdhsjdhsjdhsjdhasjdkhs",
                          style: DertTextStyle.poppins.t14w400purple,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return ListTile(
                  title: Text("Alt Kısım Yazı $index"),
                );
              },
              childCount: 20,
            ),
          ),
        ],
      ),
    );
  }

  Container _dertLogo() {
    return Container(
      height: IconSize.size30px,
      width: IconSize.size30px,
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage(ImagePath.dertLogov2),
          fit: BoxFit.fill,
        ),
        shape: BoxShape.circle,
        border: Border.all(color: DertColor.frame.darkpurple),
      ),
    );
  }
}
