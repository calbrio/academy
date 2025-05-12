# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://academy.calbrio.com"

SitemapGenerator::Sitemap.create do
  add root_path, priority: 0.5, changefreq: "weekly"

  Course.find_each do |course|
    add course_path(course), lastmod: course.updated_at
    course.lessons.each do |lesson|
      add course_lesson_path(course, lesson), lastmod: lesson.updated_at
    end
  end
end
