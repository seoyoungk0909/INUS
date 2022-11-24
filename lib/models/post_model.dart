import 'user_model.dart';

class Post {
  User writer = User();
  String title = "Title";
  String text = """
  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed sit amet eros ligula. Sed ante dui, efficitur et porta porttitor, consequat id lacus. Cras pulvinar magna vel mollis pretium. Vivamus nec orci in lacus volutpat dapibus. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam convallis sed est nec porttitor. Aliquam mollis pellentesque velit, at interdum ligula molestie sit amet.

  Maecenas faucibus sit amet nisi non faucibus. Sed laoreet congue efficitur. Nam scelerisque purus a purus tincidunt bibendum at ut neque. In sagittis felis est, nec laoreet justo cursus in. Vestibulum eu nibh tempus, luctus mi at, efficitur nulla. In hac habitasse platea dictumst. Phasellus pharetra tempor ante semper tincidunt. Etiam pretium ante sed risus vulputate, id finibus arcu venenatis.

  Suspendisse tempus malesuada tincidunt. Nunc non ante non velit posuere ornare. Maecenas malesuada lorem et vulputate fringilla. Etiam vel malesuada nunc. Etiam orci turpis, sodales nec tortor eu, suscipit condimentum lectus. Sed massa massa, tincidunt ultrices ex nec, mollis efficitur quam. Aenean sagittis, ipsum ut volutpat sodales, dolor elit lacinia ex, et euismod ipsum eros sit amet ante. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Quisque tincidunt felis blandit nulla dignissim convallis. Nunc sit amet tristique purus. Ut tortor tortor, interdum non sem vitae, condimentum maximus erat.

  Nunc tincidunt blandit convallis. Suspendisse quis malesuada eros, at lacinia ipsum. Quisque sed porta dui. Etiam ornare commodo auctor. Suspendisse rutrum urna nulla, sollicitudin lobortis ante mattis a. Aenean fermentum vestibulum nulla placerat consequat. In pretium elementum rutrum. Pellentesque posuere ac tellus eget condimentum. Donec turpis ipsum, eleifend ac mi quis, lobortis imperdiet leo.

  Cras justo ipsum, pulvinar dictum mi sit amet, fermentum mollis sapien. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nam vel justo et ante elementum volutpat ac et ante. Ut maximus diam sit amet auctor sagittis. Nullam euismod pulvinar congue. Nullam rutrum molestie nunc, a congue eros rhoncus egestas. Vestibulum congue mauris quam, suscipit vehicula magna lobortis eget.
  """;
  late DateTime timestamp;
  int likes = 0;

  Post({User? postWriter, String? postTitle, String? content}) {
    writer = postWriter ?? writer;
    title = postTitle ?? title;
    text = content ?? text;
    timestamp = DateTime.now();
  }

  String getWriterSchool() => writer.school.toString().split('.').last;
}
