<?php
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;

// Yol tanımlarını düzeltin
require __DIR__ . '/vendor/autoload.php';

// Container oluşturma
$container = new DI\Container();

// Twig ayarları (Railway'e uygun)
$container->set(Twig::class, function() {
    $twig = Twig::create(__DIR__ . '/views', [
        'cache' => false // Railway'de cache sorunları olabilir
    ]);
    return $twig;
});

// Logger ayarları
$container->set(Psr\Log\LoggerInterface::class, function () {
    $logger = new Monolog\Logger('app');
    $logger->pushHandler(new Monolog\Handler\StreamHandler('php://stderr', Monolog\Logger::DEBUG));
    return $logger;
});

// Uygulamayı oluştur
$app = DI\Bridge\Slim\Bridge::create($container);

// Error middleware
$app->addErrorMiddleware(
    $_ENV['APP_ENV'] === 'development',
    true,
    true
);

// Ana route
$app->get('/', function (Request $request, Response $response) use ($container) {
    return $container->get(Twig::class)->render($response, 'index.twig');
});

// Çalıştır
$app->run();

$app->run();
