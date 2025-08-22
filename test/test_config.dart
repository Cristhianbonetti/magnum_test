import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/// Configuração global para os testes
class TestConfig {
  static void setupTestEnvironment() {
    // Configurar timeout padrão para testes
    TestWidgetsFlutterBinding.ensureInitialized();
    
    // Configurar mocks globais se necessário
    setUpAll(() {
      // Configurações que devem ser executadas uma vez antes de todos os testes
    });
    
    tearDownAll(() {
      // Limpeza após todos os testes
    });
  }
  
  /// Configurar mocks comuns
  static void setupCommonMocks() {
    // Reset de todos os mocks antes de cada teste
    resetMocktailState();
  }
}

/// Extensões úteis para testes
extension TestExtensions on WidgetTester {
  /// Aguardar até que não haja mais animações
  Future<void> waitForAnimations() async {
    await pumpAndSettle();
  }
  
  /// Aguardar um tempo específico
  Future<void> waitForDuration(Duration duration) async {
    await pump(duration);
  }
}
