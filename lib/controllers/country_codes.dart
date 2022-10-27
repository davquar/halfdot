import 'dart:convert';

import 'package:flutter/material.dart';

class CountryCodes {
  final BuildContext context;
  late Map<String, dynamic> json;

  CountryCodes(this.context);

  load() async {
    String txt = await DefaultAssetBundle.of(context).loadString("assets/territories.json");
    json = jsonDecode(txt);
  }

  String getCountry(code) {
    try {
      return json["main"]["en"]["localeDisplayNames"]["territories"][code];
    } catch (e) {
      return code;
    }
  }
}

// # LICENSES

// ## JSON distribution of CLDR locale data for internationalization

// * assets/territories.json
// * https://github.com/unicode-org/cldr-json

// UNICODE, INC. LICENSE AGREEMENT - DATA FILES AND SOFTWARE

//     Unicode Data Files include all data files under the directories
// http://www.unicode.org/Public/, http://www.unicode.org/reports/, and
// http://www.unicode.org/cldr/data/. Unicode Data Files do not include PDF
// online code charts under the directory http://www.unicode.org/Public/.
// Software includes any source code published in the Unicode Standard or under
// the directories http://www.unicode.org/Public/,
// http://www.unicode.org/reports/, and http://www.unicode.org/cldr/data/.

//     NOTICE TO USER: Carefully read the following legal agreement. BY
// DOWNLOADING, INSTALLING, COPYING OR OTHERWISE USING UNICODE INC.'S DATA FILES
// ("DATA FILES"), AND/OR SOFTWARE ("SOFTWARE"), YOU UNEQUIVOCALLY ACCEPT, AND
// AGREE TO BE BOUND BY, ALL OF THE TERMS AND CONDITIONS OF THIS AGREEMENT. IF
// YOU DO NOT AGREE, DO NOT DOWNLOAD, INSTALL, COPY, DISTRIBUTE OR USE THE DATA
// FILES OR SOFTWARE.

//     COPYRIGHT AND PERMISSION NOTICE

//     Copyright © 1991-2019 Unicode, Inc. All rights reserved. Distributed under
// the Terms of Use in http://www.unicode.org/copyright.html.

//     Permission is hereby granted, free of charge, to any person obtaining a
// copy of the Unicode data files and any associated documentation (the "Data
// Files") or Unicode software and any associated documentation (the "Software")
// to deal in the Data Files or Software without restriction, including without
// limitation the rights to use, copy, modify, merge, publish, distribute, and/or
// sell copies of the Data Files or Software, and to permit persons to whom the
// Data Files or Software are furnished to do so, provided that (a) the above
// copyright notice(s) and this permission notice appear with all copies of the
// Data Files or Software, (b) both the above copyright notice(s) and this
// permission notice appear in associated documentation, and (c) there is clear
// notice in each modified Data File or in the Software as well as in the
// documentation associated with the Data File(s) or Software that the data or
// software has been modified.

//     THE DATA FILES AND SOFTWARE ARE PROVIDED "AS IS", WITHOUT WARRANTY OF ANY
// KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF THIRD
// PARTY RIGHTS. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR HOLDERS INCLUDED IN
// THIS NOTICE BE LIABLE FOR ANY CLAIM, OR ANY SPECIAL INDIRECT OR CONSEQUENTIAL
// DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR
// PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS
// ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THE
// DATA FILES OR SOFTWARE.

//     Except as contained in this notice, the name of a copyright holder shall
// not be used in advertising or otherwise to promote the sale, use or other
// dealings in these Data Files or Software without prior written authorization
// of the copyright holder.

