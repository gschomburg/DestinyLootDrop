var gulp = require('gulp');
var coffee = require('gulp-coffee');
var uglify = require('gulp-uglify');
var less = require('gulp-less');
var livereload = require('gulp-livereload');
var plumber = require('gulp-plumber');
var browserify = require('gulp-browserify');
var rename = require('gulp-rename');
// var sourcemaps = require('gulp-sourcemaps');

// gulp.task('js', function(){
// 	return gulp.src('./src/poc_flipboard/js/*.coffee')
// 	.pipe(plumber())
// 	.pipe(coffee())
// 	.pipe(uglify())
// 	.pipe(gulp.dest('./dist/'))
// 	.pipe(livereload());
// });

gulp.task('browserify', function(){
	return gulp.src('./src/**/js/*.coffee', {read: false})
	.pipe(plumber())
	.pipe( browserify({
			debug: true,
			transform: ['coffeeify'],
			extensions: ['.coffee']
		}))
	// .pipe(coffee())
	// .pipe(uglify())
	.pipe(rename({extname: '.js'}))
	.pipe(gulp.dest('./dist/'))
	.pipe(livereload());
});

gulp.task('less', function(){
	return gulp.src('./src/**/css/*.less')
	.pipe(plumber())
	.pipe(less())
	.pipe(gulp.dest('./dist/'))
	.pipe(livereload());
});


gulp.task('copy', function(){
	return gulp.src(['./src/**/*.html', './src/**/*.php','./src/**/*.jpg', './src/**/*.png', './src/**/*.json','./src/**/*.css','./src/**/*.js', './src/**/*.map', './src/**/*.otf', './src/**/*.mp4'])
	.pipe(gulp.dest('./dist/'))
	.pipe(livereload());
});


gulp.task('watch', function(){
	livereload.listen();
	gulp.watch('./src/**/js/*.coffee', ['browserify']);
	gulp.watch('./src/**/css/*.less', ['less']);
	gulp.watch(['./src/**/*.html', './src/**/*.json', './src/**/*.php'], ['copy']);
});

gulp.task('build', ['browserify', 'less', 'copy']);
gulp.task('default', ['build', 'watch']);

//lauch php server with
//php -S "localhost:4000" 
//php -S "localhost:4000" -c "../php.ini"
