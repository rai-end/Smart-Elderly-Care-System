import axios from 'axios';

const request = axios.create({
    baseURL: 'http://localhost:8080',
    timeout: 10000,
    headers: {
        'Content-Type': 'application/json;charset=utf-8'
    }
});


request.interceptors.request.use(
    (config) => {
        console.log(`[请求发起] ${config.method?.toUpperCase()} ${config.baseURL}${config.url}`, {
            params: config.params,
            data: config.data
        });
        const adminToken = localStorage.getItem('adminToken');
        if (adminToken) {
            config.headers.Authorization = adminToken;
        }
        return config;
    },
    (error) => {
        console.error('[请求配置错误]', error);
        return Promise.reject(error);
    }
);


request.interceptors.response.use(
    (response) => {
        const res = response.data;
        console.log(`[响应成功] ${response.config.url}`, res);
        if (res && typeof res === 'object') {
            return res;
        } else {
            return { code: 500, msg: '服务器返回格式错误', data: null };
        }
    },
    (error) => {
        let errorMsg = '服务器连接失败';
        if (error.response) {
            switch (error.response.status) {
                case 400: errorMsg = '请求参数错误'; break;
                case 401:
                    errorMsg = '未授权，请重新登录';
                    localStorage.removeItem('adminToken');
                    localStorage.removeItem('adminName');
                    break;
                case 403: errorMsg = '拒绝访问'; break;
                case 404: errorMsg = '请求的资源不存在'; break;
                case 500: errorMsg = '服务器内部错误'; break;
                default: errorMsg = `请求失败 [${error.response.status}]`;
            }
        } else if (error.request) {
            errorMsg = '网络连接超时，请检查网络';
        } else {
            errorMsg = error.message || '请求配置错误';
        }
        console.error(`[响应失败] ${error.config?.url || '未知接口'}：`, errorMsg, error);
        return { code: 500, msg: errorMsg, data: null };
    }
);

export default request;