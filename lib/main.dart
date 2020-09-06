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
      getToken: () async {
        final token = ' e63362408bc11a8c31a9954fad1b174bfc1c806a';
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

    return MaterialApp(
      title: 'GraphQL Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
            return Center(child: Text('Countries not found.'));
          }
          // 返回_countriesView列表
          Future<PostsData> edgesList =
              result.data['repository']['issues']['edges'];
          print(edgesList);
          // List allTitleList = [];
          // List allIdList = [];

          // var h = {};
          // var maxNum = 0;
          // var maxName;
          // for (var item in edgesList) {
          //   var authorName = item['node']['author']['login'];
          //   allTitleList.add(item['node']['title']);
          //   allIdList.add(item['node']['id']);
          //   if (h[authorName]) {
          //     h[authorName] = h[authorName]++;
          //   } else {
          //     h[authorName] = 1;
          //   }
          //   if (h[authorName] > maxNum) {
          //     maxName = authorName;
          //     maxNum = h[authorName];
          //   }
          // }
          // 最近100个issues中所有的标题(title) (不重复)
          // final setTitleList = allTitleList.toSet();
          // // 最近100个issues中所有的作者ID (不重复)
          // final setIdList = allIdList.toSet();
          // // print(setTitleList.length);
          // // print(setIdList.length);

          // print({maxName, maxNum}); //返回最多元素对象

          return Center(
            child: Text('data'),
          );
        },
      ),
    );
  }
}
