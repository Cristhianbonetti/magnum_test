# Magnum Bank Test App

Um aplicativo Flutter moderno que demonstra uma arquitetura limpa e escalável, com autenticação Firebase, gerenciamento de estado usando Bloc/Cubit, e testes automatizados abrangentes.

# Usuario para acesso:

User: joao@silva.com
pass: joao123

## 🏗️ Arquitetura

### Clean Architecture (Arquitetura Limpa)

O app segue os princípios da Clean Architecture, organizando o código em camadas bem definidas:

```
lib/
├── modules/
│   ├── auth/                    # Módulo de Autenticação
│   │   ├── data/               # Camada de Dados
│   │   │   ├── datasources/    # Fontes de dados (Firebase, APIs)
│   │   │   ├── models/         # Modelos de dados
│   │   │   └── repositories/   # Implementações dos repositórios
│   │   ├── domain/             # Camada de Domínio
│   │   │   ├── entities/       # Entidades de negócio
│   │   │   ├── repositories/   # Contratos dos repositórios
│   │   │   └── usecases/      # Casos de uso
│   │   └── presentation/       # Camada de Apresentação
│   │       ├── cubits/         # Gerenciamento de estado
│   │       ├── pages/          # Páginas/Widgets
│   │       └── widgets/        # Componentes reutilizáveis
│   ├── posts/                  # Módulo de Posts
│   │   ├── data/               # Estrutura similar ao auth
│   │   ├── domain/             # Entidades e casos de uso
│   │   └── presentation/       # Cubits e UI
│   └── profile/                # Módulo de Perfil
│       ├── data/               # Estrutura similar
│       ├── domain/             # Entidades e casos de uso
│       └── presentation/       # Cubits e UI
└── shared/                     # Recursos compartilhados
    ├── core/                   # Utilitários centrais
    │   ├── errors/            # Tratamento de erros
    │   ├── utils/             # Utilitários gerais
    │   └── constants/         # Constantes da aplicação
    └── widgets/                # Widgets compartilhados
```

### Princípios da Arquitetura

- **Separação de Responsabilidades**: Cada camada tem uma responsabilidade específica
- **Inversão de Dependência**: Dependências apontam para abstrações, não implementações
- **Independência de Frameworks**: O domínio não depende de frameworks externos
- **Testabilidade**: Arquitetura facilita a criação de testes unitários e de integração

## 📦 Packages e Dependências

### Dependências Principais

#### **State Management**
- **`flutter_bloc`** - Gerenciamento de estado usando Bloc/Cubit
  - *Por que usamos*: Padrão recomendado pela comunidade Flutter, facilita testes e mantém o código organizado

#### **Firebase**
- **`firebase_core`** - Inicialização do Firebase
- **`firebase_auth`** - Autenticação de usuários
- **`cloud_firestore`** - Banco de dados NoSQL em tempo real
  - *Por que usamos*: Solução robusta e escalável da Google, integração perfeita com Flutter

#### **HTTP e Networking**
- **`http`** - Cliente HTTP para APIs REST
- **`dio`** - Cliente HTTP avançado com interceptors
  - *Por que usamos*: `http` para operações simples, `dio` para funcionalidades avançadas

#### **Utilitários**
- **`equatable`** - Comparação de objetos para Bloc
- **`dartz`** - Programação funcional com Either/Left/Right
  - *Por que usamos*: Facilita o tratamento de erros e sucessos de forma funcional

### Dependências de Desenvolvimento

#### **Testes**
- **`mocktail`** - Criação de mocks para testes
- **`bloc_test`** - Testes específicos para Bloc/Cubit
- **`flutter_test`** - Framework de testes do Flutter
  - *Por que usamos*: `mocktail` é mais moderno que `mockito`, `bloc_test` facilita testes de estado

## 🧪 Testes

### Estrutura de Testes

```
test/
├── mocks/                      # Mocks para dependências
│   ├── firebase_mocks.dart    # Mocks do Firebase
│   ├── http_mocks.dart        # Mocks do HTTP client
│   └── entity_mocks.dart      # Mocks das entidades
├── modules/                    # Testes organizados por módulo
│   ├── auth/                  # Testes de autenticação
│   │   ├── data/             # Testes de datasources
│   │   └── presentation/     # Testes de cubits
│   └── posts/                # Testes de posts
│       ├── data/             # Testes de datasources
│       └── presentation/     # Testes de cubits
├── test_config.dart           # Configuração global de testes
└── README.md                  # Documentação dos testes
```

### Executando os Testes

```bash
# Executar todos os testes
flutter test

# Executar testes de um módulo específico
flutter test test/modules/auth/

# Executar um teste específico
flutter test test/modules/auth/data/datasources/auth_remote_datasource_test.dart

# Executar com cobertura
flutter test --coverage
```

### Cobertura de Testes

- **PostsRemoteDataSource**: 8 testes ✅
- **PostsCubit**: 6 testes ✅
- **AuthRemoteDataSource**: 8 testes ✅
- **AuthCubit**: 6 testes ✅

**Total: 28 testes unitários** - 100% dos componentes principais testados

## 🚀 Como Executar o App

### Pré-requisitos

- Flutter SDK 3.32.8 ou superior
- Dart 3.8.1 ou superior
- iOS Simulator ou Android Emulator


## 📱 Funcionalidades

### Módulo de Autenticação
- **Login/Registro** com email e senha
- **Gerenciamento de perfil** (nome, foto)
- **Logout** e **exclusão de conta**
- **Persistência de sessão**

### Módulo de Posts
- **Listagem paginada** de posts
- **Busca por usuário** específico
- **Contagem total** de posts
- **Pull-to-refresh** para atualização

### Módulo de Perfil
- **Visualização** de informações do usuário
- **Edição** de dados pessoais
- **Upload** de foto de perfil

## 🔧 Boas Práticas Implementadas

### 1. **Tratamento de Erros**
- Uso de `Either<Failure, Success>` para operações que podem falhar
- Tratamento consistente de exceções em todas as camadas
- Logs estruturados para debugging

### 2. **Gerenciamento de Estado**
- Estados imutáveis usando `equatable`
- Separação clara entre loading, success e error states
- Uso de `emit()` apenas quando necessário

### 3. **Injeção de Dependência**
- Uso do `Provider` para injeção de dependências
- Dependências injetadas via construtor
- Facilita testes e manutenção

### 4. **Logging Estruturado**
- Classe `AppLogger` centralizada
- Diferentes níveis de log (info, warning, error)
- Logs específicos para cada operação

### 5. **Constantes Centralizadas**
- `AppConstants` para URLs e endpoints
- Configurações centralizadas
- Fácil manutenção e alteração

### 6. **Paginação Inteligente**
- Carregamento sob demanda
- Controle de estado "hasReachedMax"
- Refresh automático quando necessário

## 🏆 Padrões de Código

### Nomenclatura
- **Classes**: PascalCase (`UserModel`, `AuthCubit`)
- **Métodos**: camelCase (`getPosts`, `updateProfile`)
- **Variáveis**: camelCase (`userName`, `isLoading`)
- **Constantes**: SCREAMING_SNAKE_CASE (`BASE_URL`)

### Estrutura de Arquivos
- **Um arquivo por classe** (exceto para estados simples)
- **Organização por módulo** e camada
- **Separação clara** entre lógica de negócio e apresentação

---

**Desenvolvido com ❤️ usando Flutter e Clean Architecture**
