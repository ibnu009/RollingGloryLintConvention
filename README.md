<img align="left" width="60" height="60" src="https://avatars1.githubusercontent.com/u/30823810?s=100&v=4"> </img>

**RollingGlory** is Company or Creative Digital Media studio based in Bandung, Indonesia.

&nbsp;
&nbsp;
## GloryConventionLint-Flutter
GloryConventionLint is judgment code for Convention lint in IDE Android Studio support Flutter.

#### Model 
* [Correct model class name](#1-correct-model-class-name)
* [Correct model file name](#2-correct-model-file-name)
* [Correct model annotation](#3-correct-model-annotation)
* [Prefer nullable for models](#4-prefer-nullable-for-models)

#### Service
* [Correct service class name](#1-correct-service-class-name)
* [Correct service file name](#2-correct-service-file-name)
* [Correct service annotation](#3-correct-service-annotation)

#### Enum 
* [Correct enum class name](#1-correct-enum-class-name)
* [Correct enum file name](#2-correct-enum-file-name)

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
#### 1. Correct model class name 
Ensure to add Model word at the end of class name in models file
~~~dart
//DO
class ProductModel {}
//DON'T
class ProductModel {}
~~~
#### 2. Correct model file name 
The file name for models must end with _model.dart
~~~dart
//DO
product_model.dart
//DON'T
product.dart
productmodel.dart
```
~~~
#### 3. Correct model annotation
Add @JsonSerializable() from Retrofit to above your class model name
~~~dart
//DO
@JsonSerializable()
class ProductModel {
  int? id;
}
//DON'T
class ProductModel {
  int? id;
}
@JsonSerializable()
~~~
#### 4. Prefer nullable for models 
Fields of Model class is preferable to have nullable field. example : String? instead of String
~~~dart
//DO
  class Product {
  String? name;
  Product({this.name});
}
//DON'T
  class Product {
  String name;
  Product({this.name});
}
~~~

### Service
#### 1. Correct service class name 
Ensure to add Services word at the end of class name in models file
~~~dart
//DO
  class GiftServices{}
  class ProductServices{}
//DON'T
  class Gift{}
  class ProductService{} // singular instead of plural
~~~
#### 2. Correct service file name 
The file name for services must end with service.dart
~~~dart
//DO
  gift_services.dart
  product_services.dart
//DON'T
  product_service.dart //singular instead of plural
  ProductRequest.dart
~~~
#### 3. Correct service annotation
Add @RestApi() from Retrofit to above your class service name
~~~dart
//DO
@RestApi() //RestApi Annotation is added
abstract class ProductServices {}
//DON'T
//Forget to add RestApi Annotation
abstract class ProductServices {}
~~~

### Enum
#### 1. Correct enum class name
Ensure to add Enum word at the end of enum class name in the file.
~~~dart
//DO
enum AvatarEnum {}
//DON'T
enum EnumAvatar {}
~~~

#### 2. Correct enum file name
Ensure to add _enum.dart prefix at the end of file name.
~~~dart
//DO
  gift_enum.dart
  product_enum.dart
//DON'T
  ProductEnum.dart
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
           <td>Variable</td>
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
           <td>Parameter</td>
            <td></td>
            <td>✅</td>
            <td></td>
            <td></td>
            <td>String param</td>
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
