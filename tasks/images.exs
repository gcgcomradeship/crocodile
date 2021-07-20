alias Crocodile.Banner
alias Crocodile.Blog
alias Crocodile.Instagram
alias Crocodile.Partner
alias Crocodile.Repo

for banner <- Repo.all(Banner) do
  new_path = String.replace(banner.path, "https://minio.crocodildo.ru/public/", "")
  Banner.changeset(banner, %{path: new_path}) |> Repo.update()
end

for module <- [Blog, Instagram, Partner] do
  for rec <- Repo.all(module) do
    new_path = String.replace(rec.image, "https://minio.crocodildo.ru/public/", "")
    module.changeset(rec, %{image: new_path}) |> Repo.update()
  end
end
