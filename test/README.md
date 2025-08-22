# Testes Automatizados - Magnum Bank Test

Este diretório contém todos os testes automatizados para o projeto Magnum Bank Test.

## Tecnologias Utilizadas

- **Flutter Test**: Framework de testes padrão do Flutter
- **Mocktail**: Biblioteca para criação de mocks
- **Bloc Test**: Biblioteca para testes de BLoC/Cubit
- **Integration Test**: Framework para testes de integração

## Como Executar os Testes

### Testes Unitários

```bash
# Executar todos os testes
flutter test

# Executar testes de um módulo específico
flutter test test/modules/auth/

# Executar um arquivo de teste específico
flutter test test/modules/auth/data/datasources/auth_remote_datasource_test.dart

# Executar testes com cobertura
flutter test --coverage
```


## Tipos de Testes Implementados

### 1. Testes de DataSources
- **AuthRemoteDataSource**: Testa interação com Firebase Authentication
- **PostsRemoteDataSource**: Testa interação com API externa via HTTP

### 2. Testes de Cubits
- **AuthCubit**: Testa gerenciamento de estado de autenticação
- **PostsCubit**: Testa gerenciamento de estado de posts

### 3. Testes de Integração
- **App Test**: Testa inicialização e navegação básica do app

## Mocks Implementados

### Firebase Mocks
- `MockFirebaseAuth`: Mock para Firebase Authentication
- `MockUser`: Mock para usuário do Firebase
- `MockUserCredential`: Mock para credenciais de usuário
- `MockUserMetadata`: Mock para metadados de usuário
- `MockFirebaseFirestore`: Mock para Firestore
- `MockCollectionReference`: Mock para referência de coleção
- `MockDocumentReference`: Mock para referência de documento
- `MockDocumentSnapshot`: Mock para snapshot de documento
- `MockQuerySnapshot`: Mock para snapshot de query
- `MockQueryDocumentSnapshot`: Mock para snapshot de documento de query
- `MockFirebaseAuthException`: Mock para exceções do Firebase Auth

### HTTP Mocks
- `MockHttpClient`: Mock para cliente HTTP
- `MockHttpResponse`: Mock para resposta HTTP
- `MockStreamedResponse`: Mock para resposta HTTP em stream

### Entity Mocks
- `MockUserEntity`: Mock para entidade de usuário
- `MockPostEntity`: Mock para entidade de post
- `MockProfileEntity`: Mock para entidade de perfil

## Cobertura de Testes

### Módulo de Autenticação
- ✅ Login com sucesso e falha
- ✅ Registro com sucesso e falha
- ✅ Logout com sucesso e falha
- ✅ Atualização de perfil
- ✅ Exclusão de conta
- ✅ Obtenção de usuário atual
- ✅ Gerenciamento de estado (AuthCubit)

### Módulo de Posts
- ✅ Obtenção de posts com paginação
- ✅ Obtenção de post por ID
- ✅ Obtenção de posts por usuário
- ✅ Contagem de posts
- ✅ Gerenciamento de estado (PostsCubit)

## Boas Práticas Implementadas

1. **Arrange-Act-Assert**: Estrutura clara para todos os testes
2. **Mocks Isolados**: Cada teste usa mocks independentes
3. **Setup e Teardown**: Configuração adequada antes e depois dos testes
4. **Testes de Sucesso e Falha**: Cobertura de cenários positivos e negativos
5. **Verificação de Chamadas**: Verificação de que os mocks foram chamados corretamente
6. **Tratamento de Exceções**: Testes para cenários de erro

## Próximos Passos

1. **Aumentar Cobertura**: Adicionar testes para repositórios e casos de uso
2. **Testes de Widget**: Implementar testes de interface do usuário
3. **Testes de Performance**: Adicionar testes de performance e memória
4. **Testes de Acessibilidade**: Implementar testes de acessibilidade
5. **CI/CD**: Configurar execução automática de testes em pipeline de CI/CD

## Dependências de Teste

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mocktail: ^1.0.3
  bloc_test: ^9.1.5
  integration_test:
    sdk: flutter
```

## Contribuindo

Ao adicionar novos testes:

1. Siga a estrutura de diretórios existente
2. Use os mocks já implementados quando possível
3. Implemente testes para sucesso e falha
4. Documente casos de teste complexos
5. Mantenha a cobertura de testes alta
6. Execute todos os testes antes de fazer commit
