use Bailador::Request::Multipart;
use Test;

plan 10;

my $content = $?FILE.IO.parent.child('image.png').slurp: :bin;
my %headers = (
    "Content-Disposition".uc,  'form-data; name="file"; filename="xxx.png"',
    "Content-Type".uc,  'image/png',
);

my $multipart = Bailador::Request::Multipart.new: :%headers, :$content;

is $multipart.name, 'file', 'parsing name';
is $multipart.filename, 'xxx.png', 'parsing filename';
is $multipart.is_upload, True, 'is a upload';
is-deeply $multipart.content, $content, 'content';
is $multipart.size, 152, 'content size';

%headers = (
    "Content-Disposition".uc,  'form-data; name="something"',
    "Content-Type".uc,  'text/plain',
);
$content = 'foobar'.encode;

$multipart = Bailador::Request::Multipart.new: :%headers, :$content;

is $multipart.name, 'something', 'parsing name';
is $multipart.filename, Str, 'no filename';
is $multipart.is_upload, False, 'is no upload';
is-deeply $multipart.content, $content, 'content';
is $multipart.size, 6, 'content size';


done-testing;
