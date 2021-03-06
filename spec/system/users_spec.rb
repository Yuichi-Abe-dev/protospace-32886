require 'rails_helper'

RSpec.describe 'ユーザー新規登録', type: :system do
  before do
    @user = FactoryBot.build(:user)
  end
  context 'ユーザー新規登録ができるとき' do 
    it '正しい情報を入力すればユーザー新規登録ができてトップページに移動する' do
       # トップページに移動する
       visit root_path
       # トップページにサインアップページへ遷移するボタンがあることを確認する
       expect(page).to have_content('新規登録')
       # 新規登録ページへ移動する
       visit new_user_registration_path
       # ユーザー情報を入力する
       fill_in 'ユーザー名', with: @user.name
       fill_in 'メールアドレス', with: @user.email
       fill_in 'パスワード（6文字以上）', with: @user.password
       fill_in 'パスワード再入力', with: @user.password_confirmation
       fill_in 'プロフィール', with: @user.profile
       fill_in '所属', with: @user.occupation
       fill_in '役職', with: @user.position
       # サインアップボタンを押すとユーザーモデルのカウントが1上がることを確認する
       expect{
         find('input[name="commit"]').click
       }.to change { User.count }.by(1)
       # トップページへ遷移したことを確認する
       expect(current_path).to eq(root_path)
       # カーソルを合わせるとログアウトボタンが表示されることを確認する
       expect(
         find('.nav').hover
       ).to have_content('ログアウト')
       # サインアップページへ遷移するボタンや、ログインページへ遷移するボタンが表示されていないことを確認する
       expect(page).to have_no_content('新規登録')
       expect(page).to have_no_content('ログイン')
    end
  end
  context 'ユーザー新規登録ができないとき' do
    it '誤った情報ではユーザー新規登録ができずに新規登録ページへ戻ってくる' do
      # トップページに移動する
      visit root_path
      # トップページにサインアップページへ遷移するボタンがあることを確認する
      expect(page).to have_content('新規登録')
      # 新規登録ページへ移動する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in 'ユーザー名', with: ''
      fill_in 'メールアドレス', with: ''
      fill_in 'パスワード（6文字以上）', with: ''
      fill_in 'パスワード再入力', with: ''
      fill_in 'プロフィール', with: ''
      fill_in '所属', with: ''
      fill_in '役職', with: ''
      # サインアップボタンを押してもユーザーモデルのカウントは上がらないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { User.count }.by(0)
      # 新規登録ページへ戻されることを確認する
      expect(current_path).to eq('/users')
    end
  end
end

RSpec.describe 'ログイン', type: :system do
  before do
    @user = FactoryBot.create(:user)
  end
  context 'ログインができるとき' do
    it '保存されているユーザーの情報と合致すればログインができる' do
      # トップページに移動する
      visit root_path
      # トップページにログインページへ遷移するボタンがあることを確認する
      expect(page).to have_content('ログイン')
      # ログインページへ遷移する
      visit new_user_session_path
      # 正しいユーザー情報を入力する
      fill_in 'メールアドレス', with: @user.email
      fill_in 'パスワード（6文字以上）', with: @user.password
      # ログインボタンを押す
      find('input[name="commit"]').click
      # トップページへ遷移することを確認する
      expect(current_path).to eq(root_path)
      # カーソルを合わせるとログアウトボタンが表示されることを確認する
      expect(
        find('.nav').hover
      ).to have_content('ログアウト')
      # ヘッダーに新規投稿用のNew Protoボタンが表示されていることを確認
      expect(
        find('.header').hover
      ).to have_content('New Proto')
      # ユーザー名が表示されているかの確認
      expect(page).to have_content(@user.name)
      # サインアップページへ遷移するボタンやログインページへ遷移するボタンが表示されていないことを確認する
      expect(page).to have_no_content('新規登録')
      expect(page).to have_no_content('ログイン')
    end
  end
  context 'ログインができないとき' do
    it '保存されているユーザーの情報と合致しないとログインができない' do
      # トップページに移動する
      visit root_path
      # トップページにログインページへ遷移するボタンがあることを確認する
      expect(page).to have_content('ログイン')
      # ログインページへ遷移する
      visit new_user_session_path
      # 正しいユーザー情報を入力する
      fill_in 'メールアドレス', with: '000000'
      fill_in 'パスワード（6文字以上）', with: '000000'
      # ログインボタンを押す
      find('input[name="commit"]').click
      # ログインページへ戻されることを確認する
      expect(current_path).to eq(new_user_session_path)
    end
  end
end

RSpec.describe 'ログアウト', type: :system do
  before do
    @user = FactoryBot.create(:user)
  end
  context 'ログアウトができるとき' do
    it 'ログイン後にログアウトボタンが正常に表示されていればログアウトできる' do
      # トップページに移動する
      visit root_path
      # トップページにログインページへ遷移するボタンがあることを確認する
      expect(page).to have_content('ログイン')
      # ログインページへ遷移する
      visit new_user_session_path
      # 正しいユーザー情報を入力する
      fill_in 'メールアドレス', with: @user.email
      fill_in 'パスワード（6文字以上）', with: @user.password
      # ログインボタンを押す
      find('input[name="commit"]').click
      # トップページへ遷移することを確認する
      expect(current_path).to eq(root_path)
      # カーソルを合わせるとログアウトボタンが表示されることを確認する
      expect(
        find('.nav').hover
      ).to have_content('ログアウト')
      #ログアウトボタンを押す
      find('.nav__logout').click
      # サインアップページへ遷移するボタンやログインページへ遷移するボタンが表示されていることを確認する
      expect(page).to have_content('新規登録')
      expect(page).to have_content('ログイン')
    end
  end
end