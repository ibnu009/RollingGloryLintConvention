<img align="left" width="60" height="60" src="https://avatars1.githubusercontent.com/u/30823810?s=100&v=4"> </img>

**RollingGlory** is Company or Creative Digital Media studio based in Bandung, Indonesia.

&nbsp;
&nbsp;
## GloryConventionLint-Flutter
GloryConventionLint is judgment code for Convention lint in IDE Android Studio support Flutter.

#### Model 
* [Correct model class name](#corret-model-class-name)
* [Correct model file name](#correct-model-file-name)
* [Correct model annotation](#correct-model-annotation)
* [Prefer nullable for model](#prefer-nullable-for-model)

#### Service
* [Correct service class name](#correct-service-class-name)
* [Correct service file name](#correct-service-file-name)
* [Correct service annotation](#correct-service-annotation)

#### Enum 
* [Correct enum class name](#correct-enum-class-name)
* [Correct enum file name](#correct-enum-file-name)

#### Request 
* [Correct request class name](#1-correct-request-class-name)
* [Correct request file name](#2-correct-request-file-name)

#### Response 
* [Correct response class name](#1-correct-response-class-name)
* [Correct response file name](#2-correct-response-file-name)

#### Other 
* [Naming Convention](#1-naming-convention)
* [Prefer single class per file](#2-prefer-single-class-per-file)    
* [Prefer static const lang variable](#3-prefer-static-const-lang-variable)    
* [Correct base response import](#4-correct-base-response-import) 
* [Correct one variable for lang](#5-prefer-one-variable-for-language) 

&nbsp;
---
&nbsp;
#### Installing 
Don't forget to add this line ***glory_convention_lint: ^x.x.x*** to your pubspec.yaml file, and run ***flutter pub get*** from terminal.
~~~gradle
dev_dependencies:
  glory_convention_lint: ^0.0.1
~~~

## Conventions

### Model
Ensure to add Model word at the end of class name in models file.
~~~dart
import 'package:json_annotation/json_annotation.dart';  
  
part 'animation_model.g.dart';  
  
@JsonSerializable()  
class AnimationModel {  
  int? id;  
  String? title;  
  String? posterURL;  
  String? imdbId;  
  
  Animation({this.id, this.title, this.posterURL, this.imdbId});  
  
   factory Animation.fromJson(Map<String, dynamic> json) =>  
      _$AnimationFromJson(json);  
  Map<String, dynamic> toJson() => _$AnimationToJson(this);  
}
~~~
#### 1. Correct model class name 
Request class always end with "Request", and must use *PascalCase*.
~~~dart
**DO:**
```dart
class ProductModel {}
```

**DON'T:**
```dart
class ProductModel {}
~~~
#### 2. Correct model file name 
Request class always end with "Request", and must use *PascalCase*.
~~~dart
//DO
class GiftRequest{}
class ProductRequest{}

//DON'T
class Gift{}
class product_request{}
~~~
#### 3. Correct model annotation
Request class always end with "Request", and must use *PascalCase*.
~~~dart
**DO:**
```dart
@JsonSerializable()
class ProductModel {
  int? id;
}
```
**DON'T:**
```dart
class ProductModel {
  int? id;
}
@JsonSerializable()
~~~
#### 4. Prefer nullable for models 
Request class always end with "Request", and must use *PascalCase*.
~~~dart
**DO:**
```dart
  class Product {
  String? name;
    Product({
      this.name,
  });
}
```
**DON'T:**
```dart
  class Product {
  String name;
    Product({
      this.name,
  });
}
~~~

#### Service
Services class must always end with "Services"
~~~dart
abstract class AvatarServices {
  factory AvatarServices(Dio dio) = _AvatarServices;

  @GET(AvatarServiceConstant.episode)
  Future<BaseListResponse<Episode>> episodes(@CancelRequest() CancelToken cancelToken);
}
~~~

#### Enum
Ensure to add Model word at the end of class name in models file.
~~~dart
enum AvatarEnum {
}
~~~

### Request
#### 1. Correct request class name 
Request class always end with "Request", and must use *PascalCase*.
~~~dart
//DO
class GiftRequest{}
class ProductRequest{}

//DON'T
class Gift{}
class product_request{}
~~~

#### 2. Correct request file name 
Request file must always end with "_request"  and should always use *snake_case* for file naming.
~~~
//DO
product_request.dart

//DON'T
ProductRequest.dart
~~~
Request file must always be put inside of request directory.
~~~
|- data
  |- network
    |- request
~~~
&nbsp;
### Response
#### 1. Correct response class name 
Response class always end with "Response", and must use *PascalCase*.
~~~dart
//DO
class GiftResponse{}
class ProductResponse{}

//DON'T
class Gift{}
class product_response{}
~~~

#### 2. Correct response file name 
Response file must always end with "_response"  and should always use *snake_case* for file naming.
~~~
//DO
product_response.dart

//DON'T
ProductResponse.dart
~~~
Response file must always be put inside of response directory.
~~~
|- data
  |- network
    |- response
~~~

&nbsp;
### Other
#### 1. Naming Convention 
<table>
    <tbody>
        <tr>
           <td rowspan=2>&nbsp;</td>
        </tr>
         <tr>
           <td>PascalCase</td>
           <td>CamelCase</td>
            <td>Plural</td>
           <td>Underscores</td>
           <td>Examples</td>
        </tr>
        <tr>
           <td>Class</td>
            <td>✅</td>
            <td></td>
            <td></td>
            <td></td>
            <td>class ModelResponse{}</td>
        </tr>
        <tr>
           <td>Service Class</td>
            <td>✅</td>
            <td></td>
            <td>✅</td>
            <td></td>
            <td>class ModelServices{}</td>
        </tr>
        <tr>
           <td>Constant Class</td>
            <td>✅</td>
            <td></td>
            <td>✅</td>
            <td></td>
            <td>class NetworkConstants{}</td>
        </tr>
        <tr>
           <td>Extension</td>
            <td>✅</td>
            <td></td>
            <td>✅</td>
            <td></td>
            <td>extension StringExtensions on String</td>
        </tr>
        <tr>
           <td>Field</td>
            <td></td>
            <td>✅</td>
            <td></td>
            <td></td>
            <td>int id;</td>
        </tr>
        <tr>
           <td>variable</td>
            <td></td>
            <td>✅</td>
            <td></td>
            <td></td>
            <td>int variable;</td>
        </tr>
        <tr>
           <td>Local variable</td>
            <td></td>
            <td>✅</td>
            <td></td>
            <td>✅</td>
            <td>int _variable;</td>
        </tr>
        <tr>
           <td>Method</td>
            <td></td>
            <td>✅</td>
            <td></td>
            <td></td>
            <td>void methodName(){}</td>
        </tr>
        <tr>
           <td>Local Method</td>
            <td></td>
            <td>✅</td>
            <td></td>
            <td>✅</td>
            <td>void _methodName(){}</td>
        </tr>
        <tr>
           <td>Enum Type</td>
            <td>✅</td>
            <td></td>
            <td></td>
            <td></td>
            <td>enum Status{}</td>
        </tr>  
    </tbody>
</table>

#### 2. Prefer Single Class Per File
Avoid Declaring multiple classes in one file. It is best practice to declare one class in one file instead of multiple of class in one files, to reduce
confusion. 
~~~dart
//DO
-- test.dart --
class One = {};

//DON'T
-- test.dart --
class One = {};
class Two = {};
~~~

#### 3. Prefer static const lang variable 
Declare variable as static const.
~~~dart
//DO
class One {
  static const variableOne = "Value"
}

//DON'T
class One {
  String variableOne = "Value";
}
~~~

#### 4. Correct base response import
Both BaseResponse and BaseListResponse must be implemented and imported from rollingglory_codebase
When an application communicates to the backend via API calls, we usually receive two type of responses. single object and multi objects.
both types need to be implemented in service file, the service file is actually an abstract class that contains 
a set of methods which is needed in order to get data from API.
~~~dart
//DO
class One {
  Future<BaseListResponse<Episode>> getEpisodes();
  Future<BaseResponse<Episode>> getEpisodeDetail();
}

//DON'T
class One {
  Future<Episode> myMethod();
}
~~~

#### 5. Prefer one variable for language
Ensure to separate the variable that represents a language, one class is supposed to have one variable.

~~~dart
//DO
-- languages/id_lang.dart --
Map<String,String> id = {};

-- languages/en_lang.dart --
Map<String,String> en = {};


//DON'T
-- languages.dart --
Map<String,String> id = {};
Map<String,String> en = {};
~~~

## Frequently Asked Questions
#### Can this work for java and kotlin languages?
*GloryConventionLint will automatically create rules for both languages.*
#### Can this be used for projects in my company?
Please this can be used for your company's project, with MIT License.
#### Does this work for an intellij java IDE?
*This might work for the Java Intelij IDE, but it's more recommended to use Intelij Android Studio*
#### Does this work for all versions of IDE Android Studio?
*This works for android studio 3.x.x, if you still use android studio 2.x.x please open ***Next to do***
&nbsp;
&nbsp;
### Other Information
You can follow us at <https://rollingglory.com/>
