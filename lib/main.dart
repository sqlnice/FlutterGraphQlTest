import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:graphqltest/PostsData.dart';

void main() {
  runApp(MyApp());
}

// StatelessWidget会使应用本身也成为一个widget，万物皆widget。包括align、padding、layout
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 往哪一个链接发送HttpLink
    final HttpLink httpLink = HttpLink(uri: 'https://api.github.com/graphql');
    final AuthLink authLink = AuthLink(
      getToken: () {
        final token = ' 3d0ea2dec588dca86e4fdc0d21e759187ada0020';
        return 'Bearer $token';
      },
    );
    final link = authLink.concat(httpLink);
    // 创建ValueNotifier，并传入HttpLink，在ValueNotifier里面我们还可以自定义网络请求
    final ValueNotifier<GraphQLClient> notifier = ValueNotifier<GraphQLClient>(
      GraphQLClient(
        link: link,
        cache: OptimisticCache(
          dataIdFromObject: typenameDataIdFromObject,
        ),
      ),
    );
    // MaterialApp入口，可定义多个参数
    return MaterialApp(
      title: 'GraphQL Test',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: GraphQLProvider(
        child: ResultView(), // 最终用来展示的是这个ResultView
        client: notifier,
      ),
    );
  }
}

class ResultView extends StatelessWidget {
  final String query = '''
                   query {
  repository(owner:"octocat", name:"Hello-World") {
    issues(last:100) {
      edges {
        node {
          id
          author {
            login
          }
          title
          state
          closed
          closedAt
          createdViaEmail
          publishedAt
          url
        }
      }
    }
  }
}
                  ''';

  @override
  Widget build(BuildContext context) {
    // Scaffold 是 Material 库提供的widget，他提供了导航、标题和body。
    return Scaffold(
      appBar: AppBar(
        title: Text('GraphQL Test'),
      ),
      // 调用由graphql_flutter提供的Query发送请求
      body: Query(
        options: QueryOptions(
          documentNode: gql(query),
        ),
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}) {
          if (result.loading) {
            return Center(child: CircularProgressIndicator());
          }

          if (result.data == null) {
            return Center(child: Text('ERROR'));
          }
          // 拿到接口数据
          final List<LazyCacheMap> edgesList =
              (result.data['repository']['issues']['edges'] as List<dynamic>)
                  .cast<LazyCacheMap>();

          List allTitleList = [];
          List allIdList = [];

          var h = {};
          var maxNum = 0;
          var maxAuthor;
          var tips = '';

          for (Map<String, dynamic> item in edgesList) {
            // 最近100个issues中所有的标题(title)
            allTitleList.add(item['node']['title']);
            // 最近100个issues中所有的作者ID
            allIdList.add(item['node']['id']);
            // 作者名称
            var authorName = item['node']['author'] != null
                ? item['node']['author']['login']
                : '';
            var isHas = h[authorName] != null ? true : false;
            if (isHas) {
              h[authorName] = h[authorName]++;
            } else {
              h[authorName] = 1;
            }
            if (h[authorName] > maxNum) {
              maxAuthor = authorName;
              maxNum = h[authorName];
            }
          }
          // 答案1
          final setTitleList = allTitleList.toSet();
          // 答案2
          final setIdList = allIdList.toSet();
          // 答案3
          tips = maxNum == 1
              ? '各位作者打成平手~'
              : "最近100个issues中 $maxAuthor 提交了最多的issues";

          print(setTitleList.length);
          print(setIdList.length);

          return Container(
            height: 60,
            margin: EdgeInsets.only(left: 5, right: 5, top: 5), // 边距
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)), //设置圆角
            ),
            child: Row(
              children: <Widget>[
                Text(tips),
              ],
            ),
          );
        },
      ),
    );
  }
}
