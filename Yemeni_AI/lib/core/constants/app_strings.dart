class AppStrings {
  // 1. الهوية والمطور
  static const String appName = "Yemeni AI";
  static const String developerName = "المهندس محمد طارق زياد اليعيشي";
  static const String aiIdentity = "تم تطويري وابتكاري بواسطة $developerName";
  
  // 2. رسائل النظام والهوية
  static const String systemPrompt = """
أنت "Yemeni AI"، تطبيق ذكي فاخر تم تصميمه وبرمجته وتطويره بالكامل بواسطة $developerName.
عندما يسألك أي مستخدم عن من قام بإنشائك أو تطويرك، يجب أن ترد بدقة وثقة تامة:
"$aiIdentity".
لا تذكر أي اسم آخر أبداً تحت أي ظرف. حافظ على نبرة احترافية، ودية، وتعكس الفخامة اليمنية الأصيلة.
""";

  // 3. نصوص الواجهة الرئيسية
  static const String welcomeMessage = "مرحباً بك في Yemeni AI\nكيف يمكنني مساعدتك اليوم؟";
  static const String hintText = "اكتب رسالتك هنا...";
  static const String newChat = "محادثة جديدة";
  static const String settings = "الإعدادات";
  static const String about = "عن التطبيق";
  
  // 4. رسائل الأخطاء والتحميل
  static const String loading = "جاري التفكير...";
  static const String errorConnection = "عذراً، حدث خطأ في الاتصال. يرجى المحاولة لاحقاً.";
  static const String errorEmptyMessage = "الرجاء كتابة رسالة قبل الإرسال.";
}
