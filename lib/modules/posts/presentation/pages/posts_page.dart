import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/posts_cubit.dart';
import '../../domain/entities/post_entity.dart';
import '../../../auth/presentation/cubits/auth_cubit.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Carregar posts quando a página inicializar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PostsCubit>().loadPosts(refresh: true);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<PostsCubit>().loadPosts();
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sair'),
          content: const Text('Tem certeza que deseja sair?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                final authCubit = context.read<AuthCubit>();
                Navigator.of(context).pop();
                await authCubit.logout();
                if (context.mounted) {
                  Navigator.of(context).pushReplacementNamed('/');
                }
              },
              child: const Text('Sair'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue[800],
            foregroundColor: Colors.white,
            title: state is AuthAuthenticated ? LayoutBuilder(
              builder: (context, constraints) {
                // Para telas pequenas, ajusta o tamanho do avatar e espaçamento
                final avatarRadius = constraints.maxWidth < 300 ? 16.0 : 18.0;
                final spacing = constraints.maxWidth < 300 ? 8.0 : 12.0;
                
                return Row(
                  children: [
                    CircleAvatar(
                      radius: avatarRadius,
                      backgroundImage: state.user.photoURL != null
                          ? NetworkImage(state.user.photoURL!)
                          : null,
                      backgroundColor: Colors.white,
                      child: state.user.photoURL == null
                          ? Text(
                              state.user.displayName?.substring(0, 1).toUpperCase() ??
                                  state.user.email.substring(0, 1).toUpperCase(),
                              style: TextStyle(
                                fontSize: avatarRadius - 2,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            )
                          : null,
                    ),
                    SizedBox(width: spacing),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            state.user.displayName ?? 'Usuário',
                            style: TextStyle(
                              fontSize: constraints.maxWidth < 300 ? 14 : 16,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text(
                            state.user.email,
                            style: TextStyle(
                              fontSize: constraints.maxWidth < 300 ? 10 : 12,
                              color: Colors.white70,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ) : const Text('Posts'),
            actions: [
              IconButton(
                onPressed: () {
                  context.read<PostsCubit>().loadPosts(refresh: true);
                },
                icon: const Icon(Icons.refresh),
                tooltip: 'Atualizar',
              ),
              if (state is AuthAuthenticated)
                IconButton(
                  onPressed: () => _showLogoutDialog(context),
                  icon: const Icon(Icons.logout),
                  tooltip: 'Sair',
                ),
            ],
          ),
          body: BlocBuilder<PostsCubit, PostsState>(
            builder: (context, postsState) {
              if (postsState is PostsLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (postsState is PostsError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Erro ao carregar posts',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        postsState.message,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<PostsCubit>().loadPosts(refresh: true);
                        },
                        child: const Text('Tentar novamente'),
                      ),
                    ],
                  ),
                );
              }

              if (postsState is PostsLoaded) {
                if (postsState.posts.isEmpty) {
                  return const Center(
                    child: Text('Nenhum post encontrado'),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<PostsCubit>().loadPosts(refresh: true);
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: postsState.posts.length + (postsState.hasReachedMax ? 0 : 1),
                    itemBuilder: (context, index) {
                      if (index == postsState.posts.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final post = postsState.posts[index];
                      return _buildPostCard(context, post);
                    },
                  ),
                );
              }

              return const Center(
                child: Text('Carregando posts...'),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildPostCard(BuildContext context, PostEntity post) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: GestureDetector(
          onTap: () {
            // Navegar para o perfil do usuário
            Navigator.of(context).pushNamed('/profile', arguments: post.userId.toString());
          },
          child: CircleAvatar(
            backgroundImage: post.userAvatar != null
                ? NetworkImage(post.userAvatar!)
                : null,
            backgroundColor: Colors.blue[100],
            child: post.userAvatar == null
                ? Text(
                    post.userName?.substring(0, 1).toUpperCase() ?? 'U',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  )
                : null,
          ),
        ),
        title: Text(
          post.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPostBody(post.body, post),
            const SizedBox(height: 8),
            Text(
              'Por: ${post.userName ?? 'Usuário'}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
        isThreeLine: true,
        onTap: () {
          // Navegar para detalhes do post
          Navigator.of(context).pushNamed('/post-detail', arguments: post);
        },
      ),
    );
  }

  Widget _buildPostBody(String body, PostEntity post) {
    if (body.length <= 100) {
      return Text(body);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${body.substring(0, 100)}...',
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: () {
            // Navegar para detalhes do post
            Navigator.of(context).pushNamed('/post-detail', arguments: post);
          },
          child: const Text('Ver mais'),
        ),
      ],
    );
  }
}
